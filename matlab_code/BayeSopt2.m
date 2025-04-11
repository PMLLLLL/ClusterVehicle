clc; clear; close all;

path = '../2025.3.3 85个数据汇总_标签.xlsx';

% 定义目标函数
objectiveFcn = @(X) TargetFunc2(X.weight1, X.weight2, X.weight3, X.weight4, ...
                               X.initDirection1, X.initDirection2, ...
                               X.refreshDirWei1,X.refreshDirWei2,X.scoreWei1,X.scoreWei2, ...
                               X.centerWei,X.rad,X.startPreNum,path,[]);

% 定义多个优化变量 (搜索空间)
vars = [
    optimizableVariable('weight1', [0.3, 0.43], 'Type', 'real')
    optimizableVariable('weight2', [0.35, 1], 'Type', 'real')
    optimizableVariable('weight3', [0, 0.4], 'Type', 'real')
    optimizableVariable('weight4', [0.3, 0.52], 'Type', 'real')
    optimizableVariable('initDirection1', [0, 1], 'Type', 'real')
    optimizableVariable('initDirection2', [0, 1], 'Type', 'real')
    optimizableVariable('refreshDirWei1', [0, 1], 'Type', 'real')
    optimizableVariable('refreshDirWei2', [0, 1], 'Type', 'real')
    optimizableVariable('scoreWei1', [0, 10], 'Type', 'real')
    optimizableVariable('scoreWei2', [0, 10], 'Type', 'real')
    optimizableVariable('centerWei', [0, 2], 'Type', 'real')
    optimizableVariable('rad', [0, 15], 'Type', 'real')
    optimizableVariable('startPreNum', [2, 15], 'Type', 'real')
];

% 循环次数
numRuns = 10;
bestSolutions = cell(numRuns,1);


% 运行贝叶斯优化
for i=1:numRuns
    results = bayesopt(objectiveFcn, vars, ...
        'AcquisitionFunctionName', 'expected-improvement-plus', ...
        'MaxObjectiveEvaluations', 200, ...
        'UseParallel', true, ...
        'Verbose', 1);
    
    % 显示最优解
    % bestX = results.XAtMinObjective;
    % bestFval = results.MinObjective;
    bestSolutions{i} = results;

end

% fprintf('最优解:\n');
% disp(bestX);
% fprintf('最小目标函数值: %.4f\n', bestFval);
%% 

figure;
x = [];
y = [];
for i=1:numRuns
    x = [x i];
    y = [y bestSolutions{i}.MinObjective];
    plot(x,y);
end

[resultmax,index] = min(y);

fprintf('最优解:\n');
disp(bestSolutions{index}.XAtMinObjective);
fprintf('最小目标函数值: %.4f\n', resultmax);

%% 目标函数
function FMI = TargetFunc2(weight1,weight2,weight3,weight4,initDirection1,initDirection2, ...
                        refreshDirWei1,refreshDirWei2,scoreWei1,scoreWei2,centerWei,rad,startPreNum,PATH,trainIdx)

    % 参数设置
    decay = 0.000001; % 衰减因子
    
    weights = [weight1,weight2,weight3,weight4];
    initDirection = [initDirection1,initDirection2];
    refreshDirWei = [refreshDirWei1,refreshDirWei2];
    scoreWei = [scoreWei1,scoreWei2];
    
    
    normalizedData = NormalizeDataFromFile(PATH,'LogNormalization');
    
    CE = CEDAS2(rad, decay,weights,initDirection,refreshDirWei,scoreWei,centerWei,startPreNum); % 用于存储聚类结果
    
    for t = 1:size(normalizedData, 1)
        % 调用 CEDAS_demo3 算法
        CE = CE.Clustering(normalizedData(t,:));
    end
    
    % 计算真实标签和混淆矩阵
    ClusterDataTable = GetClusterDataTable(CE.clusters);
    trueLables = ClusterDataTable(:,5);
    clusterLables = ClusterDataTable(:,7);
    
    % 计算分类准确度 指标
    [SS,SD,DS,~] = GetSS_SD_DS_DD(trueLables,clusterLables);
    FMI = -FowlkesandMallowsIndex(SS,SD,DS);


end
