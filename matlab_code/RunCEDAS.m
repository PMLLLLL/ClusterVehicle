clear;

% profile on;  % 开启性能分析

% 参数设置
%rad = 3; % 聚类半径
decay = 0.000001; % 衰减因子

% 初始权重
% rad = 5;
% weights = [0.4, 0.2, 0.2, 0.2]; % 
% initDirection = [1 0 1];
% refreshDirWei = [0.5 0.5];
% scoreWei = [0.2 0.8];
% centerWei = [1 0.1];

% rad = 1.5393;
% weights = [0.21746    0.22789    0.96373    0.75239]; 
% initDirection = [0.70512            0.5611           0.65681];
% refreshDirWei = [0.30789           0.81389];
% scoreWei = [0.25726      0.13327];
% centerWei = [0.86614       0.88882];

% rad = 0.99009;
% weights = [0.32871    0.38669    0.031023    0.39699]; 
% initDirection = [0.18176           0.22614           0.38067];
% refreshDirWei = [0.6013           0.37911];
% scoreWei = [0.79158      0.88265];
% centerWei = [0.9822       0.18759];

% rad = 5;
% weights = [ 0.39391    0.95873    0.20655    0.46542]; 
% initDirection = [0.97862           0.17585           0.51833];
% refreshDirWei = [0.85984           0.72199];
% scoreWei = [0.9299       0.1601];
% centerWei = [0.991        0.29533];

% 换道优化15

% rad = 3;
% weights = [0.42125    0.95847    0.085972    0.50047]; 
% initDirection = [1           0           0.5];
% refreshDirWei = [0.48617            0.3867];
% scoreWei = [0.54935      0.91597];
% centerWei = [0.90833       0.43772];

% 换道优化16

rad = 7.8895;
weights = [0.36083    0.1 0.18828    0.33959]; 
initDirection = [0.80742           0.98495           0.25819];
refreshDirWei = [0.63064           0.60046];
scoreWei = [0.64659      0.72021];
centerWei = [0.95423       0.37756];

path = '../2025.3.13 12.16换道整理.xlsx';

% 数据加载与归一化
%DataIn = readmatrix('../2025.2.25 大车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../2025.2.27 小车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../C26550、C26580真stream加磁场 .csv');
%DataIn = readmatrix('../2025.2.27 大车小车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../2025.3.3 85个数据汇总_标签.xlsx');
%DataIn = readmatrix('../2025.3.13 12.15换道整理.csv');

DataOper = DataProcessing(path);


% 聚类处理

% CE = CEDAS(1.5393, decay,weights(i,:), ...
%     initDirection, ...
%     refreshDirWei, ...
%     scoreWei, ...
%     centerWei); % 用于存储聚类结果

CE = CEDAS(rad, ...
    decay, ...
    weights, ...
    initDirection, ...
    refreshDirWei, ...
    scoreWei, ...
    centerWei); % 用于存储聚类结果

for t = 1:size(DataOper.normalizedData, 1)
    % 调用 CEDAS_demo3 算法
    CE = CE.Clustering(DataOper.normalizedData(t,:));
end

% 计算真实标签和混淆矩阵
DataOper = DataOper.GetLabel(CE.clusters);
DataOper = DataOper.GetContingencyMatrix();
%DataOper.Output2Excel('out.xlsx',CE.clusters);

% 初始化显示类
show = Visualize(CE.clusters,DataOper.trueLabels,DataOper.clusterLabels,DataOper.contingencyMatrix);
%show.ContingencyHeatMap1();
%show.ContingencyHeatMap2();
show.ClustersImg;
% 计算分类准确度RI
RI = RandIndex(DataOper.trueLabels,DataOper.clusterLabels);

fprintf('聚类结果的数量: %d 权重Weights = [ %s] RI = %s \n',...
        length(CE.clusters),sprintf('%.2f ', weights),sprintf('%.4f ', RI));





% profile off; % 关闭性能分析
% profile viewer; % 显示分析结果





