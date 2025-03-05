clear;

% 分析RI在聚类过程中的变化

% 参数设置
rad = 3; % 聚类半径
decay = 0.000001; % 衰减因子

% 初始权重
weights = [(1-0.98)/3, 0.98, (1-0.98)/3, (1-0.98)/3]; % 时间戳、位置、磁场值、车道号
initDirection = [1 0 1];
refreshDirWei = [0.5 0.5];
scoreWei = [0.2 0.8];
centerWei = [1 0.1];

path = '../2025.3.3 85个数据汇总_标签.xlsx';

% 数据加载与归一化
%DataIn = readmatrix('../2025.2.25 大车数据合并_真实标签.xlsx'); % 2025.2.27 小车数据合并_真实标签.xlsx
%DataIn = readmatrix('../2025.2.27 小车数据合并_真实标签.xlsx');% C26550、C26580真stream加磁场 .csv
%DataIn = readmatrix('../C26550、C26580真stream加磁场 .csv');
%DataIn = readmatrix('../2025.2.27 大车小车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../2025.3.3 85个数据汇总_标签.xlsx'); % 2025.3.4 11-20个数据汇总_标签.xlsx
%DataIn = readmatrix('../2025.3.4 11-20个数据汇总_标签.xlsx');

DataOper = DataProcessing(path);

% 存储每次聚类的RI值
RI = zeros(1,length(DataOper.normalizedData(:,1)));

% 聚类处理
CE = CEDAS(rad, decay,weights, ...
            initDirection, ...
            refreshDirWei, ...
            scoreWei, ...
            centerWei); % 用于存储聚类结果

for t = 1:size(DataOper.normalizedData, 1)
    % 调用 CEDAS_demo3 算法
    CE = CE.Clustering(DataOper.normalizedData(t,:));
    % 计算真实标签
    DataOper = DataOper.GetLabel(CE.clusters);
    RI(t) = RandIndex(DataOper.trueLabels,DataOper.clusterLabels);
end

% 计算混淆矩阵
DataOper = DataOper.GetContingencyMatrix();

% 初始化显示类
show = Visualize(CE.clusters,DataOper.trueLabels,DataOper.clusterLabels,DataOper.contingencyMatrix);
show.ContingencyHeatMap1();
show.ContingencyHeatMap2();
show.ClustersImg;

figure;
plot(1:length(DataOper.normalizedData(:,1)),RI);
ylabel('RI');   % y 轴标签
xlabel('输入数据的个数');
title('RI在聚类过程中的变化');% 添加标题






