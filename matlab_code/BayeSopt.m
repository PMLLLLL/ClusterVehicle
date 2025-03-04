clc; clear; close all;

% 定义目标函数
objectiveFcn = @(X) TargetFunc(X.weight1, X.weight2, X.weight3, X.weight4, ...
                               X.initDirection1, X.initDirection2, X.initDirection3, ...
                               X.refreshDirWei1,X.refreshDirWei2,X.scoreWei1,X.scoreWei2, ...
                               X.centerWei1,X.centerWei2,X.rad);

% 定义多个优化变量 (搜索空间)
vars = [
    optimizableVariable('weight1', [0, 1], 'Type', 'real')
    optimizableVariable('weight2', [0, 1], 'Type', 'real')
    optimizableVariable('weight3', [0, 1], 'Type', 'real')
    optimizableVariable('weight4', [0, 1], 'Type', 'real')
    optimizableVariable('initDirection1', [0, 1], 'Type', 'real')
    optimizableVariable('initDirection2', [0, 1], 'Type', 'real')
    optimizableVariable('initDirection3', [0, 1], 'Type', 'real')
    optimizableVariable('refreshDirWei1', [0, 1], 'Type', 'real')
    optimizableVariable('refreshDirWei2', [0, 1], 'Type', 'real')
    optimizableVariable('scoreWei1', [0, 1], 'Type', 'real')
    optimizableVariable('scoreWei2', [0, 1], 'Type', 'real')
    optimizableVariable('centerWei1', [0, 1], 'Type', 'real')
    optimizableVariable('centerWei2', [0, 1], 'Type', 'real')
    optimizableVariable('rad', [0, 15], 'Type', 'real')
];

% 运行贝叶斯优化
results = bayesopt(objectiveFcn, vars, ...
    'AcquisitionFunctionName', 'expected-improvement-plus', ...
    'MaxObjectiveEvaluations', 30, ...
    'Verbose', 1);

% 显示最优解
bestX = results.XAtMinObjective;
bestFval = results.MinObjective;

fprintf('最优解:\n');
disp(bestX);
fprintf('最小目标函数值: %.4f\n', bestFval);

