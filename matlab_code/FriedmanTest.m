%% 性能排名比较 - Friedman检验完整实现
% 作者: MATLAB助手
% 最后更新: 2023-10-15

clc; clear; close all;

%% 1. 数据准备
% 假设我们比较5种算法在10个数据集上的性能(准确率)
% 每行代表一个数据集，每列代表一种算法

performance = [
    0.85 0.82 0.83 0.79 0.81;  % 数据集1
    0.78 0.76 0.77 0.75 0.74;   % 数据集2
    0.92 0.90 0.91 0.89 0.88;   % 数据集3
    0.81 0.80 0.79 0.78 0.77;   % 数据集4
    0.87 0.85 0.86 0.84 0.83;   % 数据集5
    0.76 0.74 0.75 0.73 0.72;   % 数据集6
    0.89 0.87 0.88 0.86 0.85;   % 数据集7
    0.83 0.81 0.82 0.80 0.79;   % 数据集8
    0.90 0.88 0.89 0.87 0.86;   % 数据集9
    0.79 0.77 0.78 0.76 0.75    % 数据集10
];

algorithm_names = {'Alg1', 'Alg2', 'Alg3', 'Alg4', 'Alg5'};
dataset_names = arrayfun(@(x) sprintf('Dataset%d', x), 1:10, 'UniformOutput', false);

%% 2. 执行Friedman检验
fprintf('=== Friedman检验 ===\n');
[p_value, tbl, stats] = friedman(performance, 1, 'off');

% 显示检验结果
disp(tbl);
fprintf('p值 = %.6f\n', p_value);

if p_value < 0.05
    fprintf('结论: 拒绝原假设(p < 0.05)，算法性能存在显著差异\n');
else
    fprintf('结论: 不能拒绝原假设(p >= 0.05)，算法性能无显著差异\n');
end

%% 3. 计算并显示平均排名
fprintf('\n=== 算法平均排名 ===\n');

% 自定义排名函数处理并列情况
ranks = zeros(size(performance));
for i = 1:size(performance, 1)
    [~, ~, ranks(i,:)] = unique(performance(i,:), 'sorted');
end

% 计算平均排名
average_ranks = mean(ranks);

% 显示排名结果
for i = 1:length(algorithm_names)
    fprintf('%s: 平均排名 %.2f\n', algorithm_names{i}, average_ranks(i));
end

% 创建排名表格
rank_table = table(algorithm_names', average_ranks', ...
    'VariableNames', {'Algorithm', 'AverageRank'});
rank_table = sortrows(rank_table, 'AverageRank');

fprintf('\n算法性能排名(从好到差):\n');
disp(rank_table);

%% 4. 可视化结果
figure('Position', [100, 100, 800, 400]);

% 子图1: 性能箱线图
subplot(1,2,1);
boxplot(performance, 'Labels', algorithm_names);
title('各算法性能分布');
ylabel('性能指标');
grid on;

% 子图2: 平均排名条形图
subplot(1,2,2);
barh(average_ranks);
set(gca, 'YTick', 1:length(algorithm_names), 'YTickLabel', algorithm_names);
title('算法平均排名 (1=最好)');
xlabel('平均排名');
grid on;

%% 5. 事后多重比较(如果Friedman检验显著)
if p_value < 0.05
    fprintf('\n=== 事后多重比较 ===\n');
    
    figure;
    [c, m, h, gnames] = multcompare(stats, 'CType', 'bonferroni', 'Display', 'on');
    
    % 显示显著差异对
    fprintf('\n显著差异的算法对:\n');
    sig_pairs = 0;
    for i = 1:size(c,1)
        if c(i,3) > 0 && c(i,5) > 0  % 第一个算法显著优于第二个
            fprintf('✓ %s 显著优于 %s (p=%.4f)\n', ...
                gnames(c(i,1)), gnames(c(i,2)), c(i,6));
            sig_pairs = sig_pairs + 1;
        elseif c(i,3) < 0 && c(i,5) < 0  % 第二个算法显著优于第一个
            fprintf('✓ %s 显著优于 %s (p=%.4f)\n', ...
                gnames(c(i,2)), gnames(c(i,1)), c(i,6));
            sig_pairs = sig_pairs + 1;
        end
    end
    
    if sig_pairs == 0
        fprintf('没有发现显著差异的算法对\n');
    end
end

%% 6. 导出结果到Excel
output_filename = 'algorithm_ranking_results.xlsx';

% 创建结果表格
results = struct();
results.Algorithm = algorithm_names';
results.AverageRank = average_ranks';
results.PerformanceMean = mean(performance)';
results.PerformanceStd = std(performance)';

% 转换为表格并排序
results_table = struct2table(results);
results_table = sortrows(results_table, 'AverageRank');

% 写入Excel
writetable(results_table, output_filename, 'Sheet', 'Summary');

fprintf('\n结果已保存到: %s\n', output_filename);