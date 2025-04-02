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

% 经过磁场分层归一化后优化16(去除一点其他不相关车辆)的值 1 4/10
% rad = 2.2439;
% weights = [0.37601    0.70802    0.26881    0.37291]; 
% initDirection = [0.049363          0.52354           0.91263];
% refreshDirWei = [ 0.28429           0.97284];
% scoreWei = [0.33608      0.75551];
% centerWei = [1.2217       0.68084];

% 经过磁场分层归一化后(修改聚类中心计算1结果)优化16(去除一点其他不相关车辆)的值 0.8268 不能聚类出换道 但是结果中不是换道车辆没有被干扰很多
% rad = 0.60344;
% weights = [0.42313    0.78613    0.25564    0.37519]; 
% initDirection = [0.95774           0.076758          0.087588];
% refreshDirWei = [0.21223           0.01466];
% scoreWei = [0.97089      0.66766];
% centerWei = [1     1];

% 经过磁场分层归一化后(修改聚类中心计算2结果)优化16(去除一点其他不相关车辆)的值 1 3/10
% rad = 9.7269;
% weights = [0.34965    0.35665    0.39604    0.35799]; 
% initDirection = [0.020604          0.41564           0.050466];
% refreshDirWei = [0.00667           0.14179];
% scoreWei = [0.70235      0.21215];
% centerWei = [0.95566 1];

% 多辆车分层归一化后优化的值 0.9940
rad = 0.41974;
weights = [0.34965    0.35665    0.39604    0.35799]; 
initDirection = [0.28821           0.84255           0.58017];
refreshDirWei = [0.50008           0.67771];
scoreWei = [0.7802 0.35717];
centerWei = [1       0.11883];

% 聚类结果的数量: 86 总体的 RI = 0.9938  JC = 0.6535  FMI = 0.7906 
% 聚类结果的数量: 86 大车的 RI = 0.9933  JC = 0.6969  FMI = 0.8216 
% 聚类结果的数量: 86 小车的 RI = 0.9732  JC = 0.6363  FMI = 0.7892 
% 聚类结果的数量: 86 大车小车的加权 RI = 0.9775  JC = 0.6494  FMI = 0.7961 

% 多辆车分层归一化后优化的值 0.9940
% rad = 8.9981;
% weights = [0.42604    0.36964    0.15645    0.3783]; 
% initDirection = [0.66952           0.070668];
% refreshDirWei = [0.26757           0.28959];
% scoreWei = [0.084305      4.1411];
% centerWei = [1       0.11883];

% 聚类结果的数量: 83 总体的 RI = 0.9960  JC = 0.7652  FMI = 0.8670 
% 聚类结果的数量: 83 大车的 RI = 0.9962  JC = 0.8183  FMI = 0.9002 
% 聚类结果的数量: 83 小车的 RI = 0.9789  JC = 0.7229  FMI = 0.8415 
% 聚类结果的数量: 83 大车小车的加权 RI = 0.9826  JC = 0.7434  FMI = 0.8541 

% 多辆车分层归一化后优化距离计算和方向计算优化的值 0.99402
% rad = 0.35682;
% weights = [0.39781    0.88412    0.30307    0.36923]; 
% initDirection = [0.57776           0.83494           0.54061];
% refreshDirWei = [0.10241            0.8558];
% scoreWei = [0.010156      6.6696];
% centerWei = [1.9801       0.11883];

% % 多辆车分层归一化后优化距离计算和方向计算优化2的值 0.99402
% rad = 6.6142;
% weights = [0.35648    0.41781    0.32681    0.48458]; 
% initDirection = [0.89128          0.00093824          0.9159];
% refreshDirWei = [0.023741          0.55626];
% scoreWei = [0.083191      0.96666];
% centerWei = [1.9801       0.11883];

% 多辆车分层归一化后优化距离计算和方向计算优化3的值 0.9928
% rad = 1.5212;
% weights = [0.34137    0.5877     0.14721    0.47047]; 
% initDirection = [0.16302           0.64315           0.017231];
% refreshDirWei = [0.14839           0.96115 ];
% scoreWei = [1.7     1.7603];
% centerWei = [1.9801       0.11883];

% 多辆车分层归一化后优化距离计算和方向计算优化3的值 0.9928
% rad = 10;
% weights = [0.35882    0.7083     0.38101    0.43961]; 
% initDirection = [0.51782           0.21022           0.076046];
% refreshDirWei = [0.80182           0.19046];
% scoreWei = [0.31148      0.73333];
% centerWei = [1.9801       0.11883];



path = '../2025.3.3 85个数据汇总_标签.xlsx';

% 数据加载与归一化
%DataIn = readmatrix('../2025.2.25 大车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../2025.2.27 小车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../C26550、C26580真stream加磁场 .csv');
%DataIn = readmatrix('../2025.2.27 大车小车数据合并_真实标签.xlsx');
%DataIn = readmatrix('../2025.3.3 85个数据汇总_标签.xlsx');
%DataIn = readmatrix('../2025.3.13 12.15换道整理.xlsx');
%DataIn = readmatrix('../2025.3.13 12.16换道整理.xlsx');
%DataIn = readmatrix('../2025.3.21 12.16换道整理 - 减少其他干扰值.xlsx');
%DataIn = readmatrix('../2025.3.26 12.16原始数据(除去磁场方向unknow的值).xlsx');

DataOper = DataProcessing(path);

% 聚类处理

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
% DataOper = DataOper.GetContingencyMatrix();
% DataOper.Output2Excel('out.xlsx',CE.clusters);

% 初始化显示类
show = Visualize(CE.clusters,DataOper.trueLabels,DataOper.clusterLabels,DataOper.contingencyMatrix);
%show.ContingencyHeatMap1();
%show.ContingencyHeatMap2();
show.ClustersImg;

%% 分别计算总体结果的标签 小车的标签 大车的标签
ClusterDataTable = GetClusterDataTable(CE.clusters);
littlevehicleDataTable = ClusterDataTable(ClusterDataTable(:,6)==1,:);
bigvehicleDataTable = ClusterDataTable(ClusterDataTable(:,6)==2,:);

trueLables = ClusterDataTable(:,5);
clusterLables = ClusterDataTable(:,7);
littlevehicletrueLables = littlevehicleDataTable(:,5);
littlevehicleclusterLables = littlevehicleDataTable(:,7);
bigvehicletrueLables = bigvehicleDataTable(:,5);
bigvehicleclusterLables = bigvehicleDataTable(:,7);
%% 分别计算总体 大车 小车的RI JC FMI

[RI,JC,FMI]=GetRI_JC_FMI(trueLables,clusterLables);
[littleRI,littleJC,littleFMI]=GetRI_JC_FMI(littlevehicletrueLables,littlevehicleclusterLables);
[bigRI,bigJC,bigFMI]=GetRI_JC_FMI(bigvehicletrueLables,bigvehicleclusterLables);

weightRI = 519/2414*littleRI + 1895/2414*bigRI;
weightJC = 519/2414*littleJC + 1895/2414*bigJC;
weightFMI = 519/2414*littleFMI + 1895/2414*bigFMI;


fprintf('聚类结果的数量: %d 总体的 RI = %s JC = %s FMI = %s\n',...
    length(CE.clusters),sprintf('%.4f ', RI),sprintf('%.4f ', JC),sprintf('%.4f ', FMI));
fprintf('聚类结果的数量: %d 大车的 RI = %s JC = %s FMI = %s\n',...
    length(CE.clusters),sprintf('%.4f ', littleRI),sprintf('%.4f ', littleJC),sprintf('%.4f ', littleFMI));
fprintf('聚类结果的数量: %d 小车的 RI = %s JC = %s FMI = %s\n',...
    length(CE.clusters),sprintf('%.4f ', bigRI),sprintf('%.4f ', bigJC),sprintf('%.4f ', bigFMI));
fprintf('聚类结果的数量: %d 大车小车的加权 RI = %s JC = %s FMI = %s\n',...
    length(CE.clusters),sprintf('%.4f ', weightRI),sprintf('%.4f ', weightJC),sprintf('%.4f ', weightFMI));
%%




