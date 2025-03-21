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

% 换道优化15 分层归一化后 0.9782

% rad = 12.593;
% weights = [0.3988     0.77987    0.17734    0.46365]; 
% initDirection = [0.64559           0.25003           0.88524];
% refreshDirWei = [0.98384           0.30388];
% scoreWei = [0.057353      0.73229];
% centerWei = [0.99891        0.926];

% 换道磁场未归一化优化16 0.8794
% rad = 7.8895;
% weights = [0.36083    0.1 0.18828    0.33959]; 
% initDirection = [0.80742           0.98495           0.25819];
% refreshDirWei = [0.63064           0.60046];
% scoreWei = [0.64659      0.72021];
% centerWei = [0.95423       0.37756];

% 换道磁场未归一化优化16 2 0.9598
% rad = 4.8228;
% weights = [0.39383    0.40392    0.35966    0.45323]; 
% initDirection = [0.807            0.48447           0.70941];
% refreshDirWei = [0.92912           0.74917];
% scoreWei = [0.56557      0.57865];
% centerWei = [0.92316       0.28691];

% 经过磁场分层归一化后优化16的值 0.9598
% rad = 11.724;
% % weights = [0.42901    0.52784    0.37931    0.3231]; 
% weights = [1    1    1    1]; 
% initDirection = [0.81637           0.16181           0.86436];
% refreshDirWei = [0.46104           0.70625];
% scoreWei = [0.86181      0.97457];
% centerWei = [0.96617       0.44282];

% 经过磁场分层归一化后优化16(去除一点其他不相关车辆)的值 0.9110
rad = 2.1502;
weights = [0.41993    0.40206    0.31575    0.50162]; 
initDirection = [0.94102           0.81151           0.021649];
refreshDirWei = [ 0.0867           0.75983];
scoreWei = [0.43352      0.49883];
centerWei = [0.14729       0.56884];

% 多辆车分层归一化后优化的值 0.9924
% rad = 0.41974;
% weights = [0.38865    0.52207    0.27358    0.46901]; 
% initDirection = [0.28821           0.84255           0.58017];
% refreshDirWei = [0.50008           0.67771];
% scoreWei = [0.7802       0.35717];
% centerWei = [0.97093       0.11883];

path = '../2025.3.13 12.16换道整理.xlsx';

% 数据加载与归一化
%DataIn = readmatrix('../2025.2.25 大车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../2025.2.27 小车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../C26550、C26580真stream加磁场 .csv');
%DataIn = readmatrix('../2025.2.27 大车小车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../2025.3.3 85个数据汇总_标签.xlsx');
%DataIn = readmatrix('../2025.3.13 12.15换道整理.xlsx');
%DataIn = readmatrix('../2025.3.13 12.16换道整理.xlsx');
%DataIn = readmatrix('../2025.3.21 12.16换道整理 - 减少其他干扰值.xlsx');

DataOper = DataProcessing(path);


% 聚类处理

CE = CEDAS(rad, ...
    decay, ...
    weights, ...
    initDirection, ...
    refreshDirWei, ...
    scoreWei, ...
    centerWei); % 用于存储聚类结果

fid = fopen('debug_log.txt', 'w'); % 打开或创建文件用于写入
for t = 1:size(DataOper.normalizedData, 1)
    fprintf(fid, '第%d个数据: ',t); % 写入日志文件
    % 调用 CEDAS_demo3 算法
    CE = CE.Clustering(DataOper.normalizedData(t,:),fid);
end
fclose(fid); % 关闭文件
% 计算真实标签和混淆矩阵
DataOper = DataOper.GetLabel(CE.clusters);
% DataOper = DataOper.GetContingencyMatrix();
% DataOper.Output2Excel('out.xlsx',CE.clusters);

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





