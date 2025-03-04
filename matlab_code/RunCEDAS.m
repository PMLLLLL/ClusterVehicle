clear;

% profile on;  % 开启性能分析

% 参数设置
rad = 3; % 聚类半径
decay = 0.000001; % 衰减因子

% 初始权重
weights = [0.4, 0.2, 0.2, 0.2]; % 时间戳、位置、磁场值、车道号
initDirection = [1 0 1];

path = '../2025.3.3 85个数据汇总_标签.xlsx';

% 数据加载与归一化
%DataIn = readmatrix('../2025.2.25 大车数据合并_真实标签.xlsx'); % 2025.2.27 小车数据合并_真实标签.xlsx
%DataIn = readmatrix('../2025.2.27 小车数据合并_真实标签.xlsx');% C26550、C26580真stream加磁场 .csv
%DataIn = readmatrix('../C26550、C26580真stream加磁场 .csv');
%DataIn = readmatrix('../2025.2.27 大车小车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../2025.3.3 85个数据汇总_标签.xlsx'); % 2025.3.4 11-20个数据汇总_标签.xlsx

% DataIn = readmatrix('../2025.3.4 11-20个数据汇总_标签.xlsx');
% DataIn = sortrows(DataIn, 3); % 按照第三列（位置Y）从小到大排序
% NormalizedData = NormalizeData(DataIn);

DataOper = DataProcessing(path);


% 产生遍历权重
% 选择哪个权重
for WeightNum = 1:4
    generateWeights = GenerateWeights(1);
    [weights,count] = generateWeights.Percentage(4,WeightNum);
    
    RI = zeros(1,count);
    
    % 聚类处理
    for i = 1:count
        CE = CEDAS(rad, decay,weights(i,:), initDirection); % 用于存储聚类结果

        for t = 1:size(DataOper.normalizedData, 1)
            % 调用 CEDAS_demo3 算法
            CE = CE.Clustering(DataOper.normalizedData(t,:));
        end
    
        % 可视化
        show = Visualize(CE.clusters);
        % show.ContingencyHeatMap1();
        % show.ContingencyHeatMap2();
        % show.ClustersImg;
        % 计算分类准确度RI
        RI(i) = RandIndex(show.trueLabels,show.clusterLabels);
    
        fprintf('第%d次聚类结果的数量: %d 权重Weights = [ %s] RI = %s \n',...
                i,length(CE.clusters),sprintf('%.2f ', weights(i,:)),sprintf('%.4f ', RI(i)));
    end
    
    % 画出变化趋势  

    % figure;
    subplot(2,2,WeightNum);
    plot(weights(:,WeightNum)',RI);
    ylabel('RI');   % y 轴标签

    if(WeightNum == 1) 
        title('RI随信标号权重的变化');% 添加标题
        xlabel('信标号权重');   % x 轴标签
    elseif(WeightNum == 2)
        title('RI随车道号权重的变化');% 添加标题
        xlabel('车道号权重'); 
    elseif(WeightNum == 3)
        title('RI随时间戳权重的变化');% 添加标题
        xlabel('时间戳权重'); 
    elseif(WeightNum == 4)
        title('RI随磁场值权重的变化');% 添加标题
        xlabel('磁场值权重'); 
    end

end

% 设置四个图的共同标题
sgtitle(sprintf('大车小车一起 rad = %.2f direction=[ %s] RI变化趋势',rad,sprintf('%.f ', initDirection)));

% profile off; % 关闭性能分析
% profile viewer; % 显示分析结果





