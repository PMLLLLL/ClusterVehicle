clear;

% profile on;  % 开启性能分析

% 参数设置
decay = 0.000001; % 衰减因子

% 多辆车分层归一化后优化的值 CEDAS1
% rad = 11.573;
% weights = [0.35192    0.38106    0.029329    0.50981]; 
% initDirection = [0.59369           0.082637];
% refreshDirWei = [0.25683           0.34303];
% scoreWei = [0.032742      5.1269];
% startPreNum = 13.902;

% 聚类结果的数量: 80 总体的 RI = 0.9960  JC = 0.7647  FMI = 0.8667 
% 聚类结果的数量: 80 大车的 RI = 0.9957  JC = 0.7966  FMI = 0.8869 
% 聚类结果的数量: 80 小车的 RI = 0.9845  JC = 0.7935  FMI = 0.8859 
% 聚类结果的数量: 80 大车小车的加权 RI = 0.9869  JC = 0.7942  FMI = 0.8861 

% 多辆车分层归一化后优化的值 CEDAS1
rad = 0.18053;
weights = [0.36873    0.35803    0.23627    0.45407]; 
initDirection = [0.72665           0.17735];
%refreshDirWei = [0.22222           0.42393];
refreshDirWei = [0.25683           0.34303];
scoreWei = [0.00052025     4.6355];
startPreNum = 10.572;

% 聚类结果的数量: 96 总体的 RI = 0.9965  JC = 0.7868  FMI = 0.8809 
% 聚类结果的数量: 96 大车的 RI = 0.9961  JC = 0.8102  FMI = 0.8954 
% 聚类结果的数量: 96 小车的 RI = 0.9835  JC = 0.7748  FMI = 0.8763 
% 聚类结果的数量: 96 大车小车的加权 RI = 0.9862  JC = 0.7824  FMI = 0.8804 


PATH = '../2025.3.3 85个数据汇总_标签.xlsx';

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


normalizedData = NormalizeDataFromFile(PATH,'HierarchicalNormalization');

% 聚类处理

CE = CEDAS1(rad, ...
    decay, ...
    weights, ...
    initDirection, ...
    refreshDirWei, ...
    scoreWei, ...
    startPreNum); % 用于存储聚类结果

for t = 1:size(normalizedData, 1)
    % 调用 CEDAS_demo3 算法
    CE = CE.Clustering(normalizedData(t,:));
end

% 显示聚类结果
ClustersImg(CE.clusters);


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




