function [trainRI,rad,weights,initDirection,refreshDirWei,scoreWei,centerWei] = ClusterAndBayeSopt(path,numRuns,perBayeSoptNum,trainIdx)

    % 
    % 定义目标函数
    objectiveFcn = @(X) TargetFunc(X.weight1, X.weight2, X.weight3, X.weight4, ...
                                   X.initDirection1, X.initDirection2, X.initDirection3, ...
                                   X.refreshDirWei1,X.refreshDirWei2,X.scoreWei1,X.scoreWei2, ...
                                   X.centerWei1,X.centerWei2,X.rad,path,trainIdx);
    
    % 定义多个优化变量 (搜索空间)
    vars = [
        optimizableVariable('weight1', [0.3, 0.43], 'Type', 'real')
        optimizableVariable('weight2', [0.35, 1], 'Type', 'real')
        optimizableVariable('weight3', [0, 0.4], 'Type', 'real')
        optimizableVariable('weight4', [0.3, 0.52], 'Type', 'real')
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
    
    % 循环次数
    bestSolutions = cell(numRuns,1);
    
    
    % 运行贝叶斯优化
    for i=1:numRuns
        results = bayesopt(objectiveFcn, vars, ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ...
            'MaxObjectiveEvaluations', perBayeSoptNum, ...
            'Verbose', 0);
        
        % 显示最优解
        % bestX = results.XAtMinObjective;
        % bestFval = results.MinObjective;
        bestSolutions{i} = results;
    
    end
    
    x = [];
    y = [];
    for i=1:numRuns
        x = [x i];
        y = [y bestSolutions{i}.MinObjective];
    end
    
    
    [resultmax,index] = min(y);
    trainRI = resultmax;

    rad = bestSolutions{index}.XAtMinObjective.rad;

    weights = [bestSolutions{index}.XAtMinObjective.weight1,...
               bestSolutions{index}.XAtMinObjective.weight2,...
               bestSolutions{index}.XAtMinObjective.weight3,...
               bestSolutions{index}.XAtMinObjective.weight4];
    initDirection = [bestSolutions{index}.XAtMinObjective.initDirection1,...
                     bestSolutions{index}.XAtMinObjective.initDirection2,...
                     bestSolutions{index}.XAtMinObjective.initDirection3];
    refreshDirWei = [bestSolutions{index}.XAtMinObjective.refreshDirWei1,...
                     bestSolutions{index}.XAtMinObjective.refreshDirWei2];
    scoreWei = [bestSolutions{index}.XAtMinObjective.scoreWei1,...
                bestSolutions{index}.XAtMinObjective.scoreWei2];
    centerWei = [bestSolutions{index}.XAtMinObjective.centerWei1,...
                 bestSolutions{index}.XAtMinObjective.centerWei2];
    % fprintf('最优解:\n');
    % disp(bestSolutions{index}.XAtMinObjective);
    % fprintf('最小目标函数值: %.4f\n', resultmax);

end