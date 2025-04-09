% 判断方法改进效果的好坏

clear;

DECAY = 0.000001; % 衰减因子

% 读取数据并进行归一化
PATH = '../2025.3.3 85个数据汇总_标签.xlsx';
originData = readmatrix(PATH);
dataSize = size(originData, 1);
METHOD_COMPARE = {@CEDAS, @CEDAS1,@CEDASSSSS};
METHODS_NAME_CEDAS = string(cellfun(@func2str, METHOD_COMPARE, 'UniformOutput', false));
METHODS_NUM = length(METHODS_NAME_CEDAS);

% 读取20input 的一共20组参数
PARAMETERS_FILE_NAME = "20input.mat";
inputParams = cellfun(@(x) x.XAtMinObjective, load(PARAMETERS_FILE_NAME).bestSolutions, 'UniformOutput', false)';
PARAS_NUM = length(inputParams);

% 用一个table存储所有参数
% for i = 1:length(inputParams)
%     paraTable(i,:) = inputParams{i};
% end 
% 用来观察所有参数的值

% 记录运行次数
clusterCounts = 0;

dataStore1 = zeros(3,PARAS_NUM*METHODS_NUM);
dataStore2 = zeros(3,PARAS_NUM*METHODS_NUM);
dataStore3 = zeros(3,PARAS_NUM*METHODS_NUM);
dataStore4 = zeros(3,PARAS_NUM*METHODS_NUM);

normalizedData = NormalizeData(originData,"MaxMinNormalization");
normalizedData = sortrows(normalizedData,3);

for i = 1:length(METHOD_COMPARE)

    % 对20组参数运行结果
    for para = inputParams

        CE = METHOD_COMPARE{i}(para{1}.rad, ...
        DECAY, ...
        [para{1}.weight1 para{1}.weight2 para{1}.weight3 para{1}.weight4],...
        [para{1}.initDirection1 para{1}.initDirection2 para{1}.initDirection3], ...
        [para{1}.refreshDirWei1 para{1}.refreshDirWei2], ...
        [para{1}.scoreWei1 para{1}.scoreWei2], ...
        [para{1}.centerWei1 para{1}.centerWei2]);

        % 输出参数方法值
        fprintf(['当前方法:%s   \n' ...
            '当前参数: \n'],class(CE));
        disp(para{1});

        % 调用 CEDAS_demo3 算法
        for t = 1:dataSize
            CE = CE.Clustering(normalizedData(t,:));
        end
        clusterCounts = clusterCounts + 1;

        % 获取聚类结果标签和真实标签
        ClusterDataTable = GetClusterDataTable(CE.clusters);
        littlevehicleDataTable = ClusterDataTable(ClusterDataTable(:,6)==1,:);
        bigvehicleDataTable = ClusterDataTable(ClusterDataTable(:,6)==2,:);

        trueLables = ClusterDataTable(:,5);
        clusterLables = ClusterDataTable(:,7);
        littlevehicletrueLables = littlevehicleDataTable(:,5);
        littlevehicleclusterLables = littlevehicleDataTable(:,7);
        bigvehicletrueLables = bigvehicleDataTable(:,5);
        bigvehicleclusterLables = bigvehicleDataTable(:,7);
        

        % 计算结果
        [RI,JC,FMI]=GetRI_JC_FMI(trueLables,clusterLables);
        [littleRI,littleJC,littleFMI]=GetRI_JC_FMI(littlevehicletrueLables,littlevehicleclusterLables);
        [bigRI,bigJC,bigFMI]=GetRI_JC_FMI(bigvehicletrueLables,bigvehicleclusterLables);

        weightRI = 0.6*bigRI + 0.4*littleRI;
        weightJC = 0.6*bigJC + 0.4*littleJC;
        weightFMI = 0.6*bigFMI + 0.4*littleFMI;

        fprintf('第%d次聚类结果的数量: %d 总体的 RI = %s JC = %s FMI = %s\n',...
            clusterCounts,length(CE.clusters),sprintf('%.4f ', RI),sprintf('%.4f ', JC),sprintf('%.4f ', FMI));
        fprintf('大车的 RI = %s JC = %s FMI = %s\n',...
            sprintf('%.4f ', littleRI),sprintf('%.4f ', littleJC),sprintf('%.4f ', littleFMI));
        fprintf('小车的 RI = %s JC = %s FMI = %s\n',...
            sprintf('%.4f ', bigRI),sprintf('%.4f ', bigJC),sprintf('%.4f ', bigFMI));
        fprintf('大车小车的加权 RI = %s JC = %s FMI = %s\n',...
            sprintf('%.4f ', weightRI),sprintf('%.4f ', weightJC),sprintf('%.4f ', weightFMI));

        % 保存结果
        dataStore1(:,clusterCounts) = [RI,JC,FMI]';
        dataStore2(:,clusterCounts) = [littleRI,littleJC,littleFMI]';
        dataStore3(:,clusterCounts) = [bigRI,bigJC,bigFMI]';
        dataStore4(:,clusterCounts) = [weightRI,weightJC,weightFMI]';
    end
end

dataRI = reshape(dataStore1(1,:),20,METHODS_NUM);
dataJC = reshape(dataStore1(2,:),20,METHODS_NUM);
dataFMI = reshape(dataStore1(3,:),20,METHODS_NUM);

littledataRI = reshape(dataStore2(1,:),20,METHODS_NUM);
littledataJC = reshape(dataStore2(2,:),20,METHODS_NUM);
littledataFMI = reshape(dataStore2(3,:),20,METHODS_NUM);

bigdataRI = reshape(dataStore3(1,:),20,METHODS_NUM);
bigdataJC = reshape(dataStore3(2,:),20,METHODS_NUM);
bigdataFMI = reshape(dataStore3(3,:),20,METHODS_NUM);

weightdataRI = reshape(dataStore4(1,:),20,METHODS_NUM);
weightdataJC = reshape(dataStore4(2,:),20,METHODS_NUM);
weightdataFMI = reshape(dataStore4(3,:),20,METHODS_NUM);

dataAll=[dataRI;
        dataJC;
        dataFMI;
        littledataRI;
        littledataJC;
        littledataFMI;
        bigdataRI;
        bigdataJC;
        bigdataFMI;
        weightdataRI;
        weightdataJC;
        weightdataFMI];

dataNum = length(dataAll(:,1))/20;

% Friedman检验

%% 1. 数据准备
% 4. 可视化结果
figure('Position', [100, 100, 800, 400]);
for Num = 1:dataNum
    performance = 1-dataAll((Num*20 - 19):Num*20,:);

    dataset_names = arrayfun(@(x) sprintf('Dataset%d', x), 1:20, 'UniformOutput', false);
    
    % 2. 执行Friedman检验
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
    
    
    % 3. 计算并显示平均排名
    fprintf('\n=== 算法平均排名 ===\n');
    
    % 自定义排名函数处理并列情况
    ranks = zeros(size(performance));
    for i = 1:size(performance, 1)
        [~, ~, ranks(i,:)] = unique(performance(i,:), 'sorted');
    end
    
    % 计算平均排名
    average_ranks = mean(ranks);
    
    % 显示排名结果
    for i = 1:length(METHODS_NAME_CEDAS)
        fprintf('%s: 平均排名 %.2f\n', METHODS_NAME_CEDAS{i}, average_ranks(i));
    end
    
    % 创建排名表格
    rank_table = table(METHODS_NAME_CEDAS', average_ranks', ...
        'VariableNames', {'Algorithm', 'AverageRank'});
    rank_table = sortrows(rank_table, 'AverageRank');
    
    fprintf('\n算法性能排名(从好到差):\n');
    disp(rank_table);
    
    % 子图2: 平均排名条形图
    subplot(4,3,Num);
    barh(average_ranks);
    set(gca, 'YTick', 1:length(METHODS_NAME_CEDAS), 'YTickLabel', METHODS_NAME_CEDAS);
    title('算法平均排名 (1=最好)');
    % xtitle = sprintf("平均排名 %d ",Num);
    xlabel("平均排名");
    grid on;
end
%%
% 5. 事后多重比较(如果Friedman检验显著)
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
