% 定义目标函数（2维Rosenbrock函数）
% rosenbrock = @(x) (1-x(1))^2 + 100*(x(2)-x(1)^2)^2;

PATH = '../2025.3.3 85个数据汇总_标签.xlsx';


objectiveFcn = @(X) TargetFunc2(X(1), X(2), X(3), X(4), ...
                               X(5), X(6), ...
                               X(7), ...
                               X(8), ...
                               X(9), ...
                               X(10), ...
                               X(11),PATH);

% 调用优化器
[x, fval] = genericGAoptimizer(objectiveFcn, 11, ...
    'lb', [0, 0,0,0,0,0,0,0,0,0,2], ...  % 变量下界
    'ub', [1, 1,1,1,1,1,1,1,1,15,15], ...    % 变量上界
    'options', optimoptions('ga', 'Display', 'iter', 'MaxGenerations', 100));

% 可视化结果
% scatter(x(1), x(2), 100, 'r', 'filled');
% hold on;
% fcontour(@(x,y) arrayfun(@(a,b) rosenbrock([a,b]),x,y), [-2 2 -2 2]);

%% 目标函数
function FMI = TargetFunc2(weight1,weight2,weight3,weight4, ...
                           initDirection1,initDirection2, ...
                           refreshDirWei, ...
                           scoreWei, ...
                           centerWei, ...
                           rad, ...
                           startPreNum,PATH)

    % 参数设置
    decay = 0.000001; % 衰减因子
    
    weights = [weight1,weight2,weight3,weight4];
    initDirection = [initDirection1,initDirection2];
    
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


function [x_opt, fval, exitflag, output] = genericGAoptimizer(fun, nvars, varargin)
% GENERICGAOPTIMIZER 通用遗传算法优化器
% 输入参数：
%   fun      - 目标函数句柄（接受向量输入，返回标量）
%   nvars    - 变量个数
% 可选参数（名称-值对）：
%   lb       - 变量下界（默认全-Inf）
%   ub       - 变量上界（默认全+Inf）
%   A        - 线性不等式约束矩阵 A*x ≤ b
%   b        - 线性不等式约束向量
%   Aeq      - 线性等式约束矩阵 Aeq*x = beq
%   beq      - 线性等式约束向量
%   nonlcon  - 非线性约束函数句柄
%   options  - 遗传算法选项结构体
% 输出：
%   x_opt    - 最优解
%   fval     - 最优目标函数值
%   exitflag - 退出标志
%   output   - 优化过程信息

%% 参数解析
p = inputParser;
addRequired(p, 'fun', @(x) isa(x, 'function_handle'));
addRequired(p, 'nvars', @(x) isscalar(x) && x > 0);
addParameter(p, 'lb', -inf(1,nvars), @(x) isvector(x) && length(x)==nvars);
addParameter(p, 'ub', inf(1,nvars), @(x) isvector(x) && length(x)==nvars);
addParameter(p, 'A', [], @ismatrix);
addParameter(p, 'b', [], @isvector);
addParameter(p, 'Aeq', [], @ismatrix);
addParameter(p, 'beq', [], @isvector);
addParameter(p, 'nonlcon', [], @(x) isempty(x) || isa(x, 'function_handle'));
addParameter(p, 'options', [], @(x) isempty(x) || isa(x, 'optim.options.GaOptions'));

parse(p, fun, nvars, varargin{:});

%% 默认选项设置
defaultOptions = optimoptions('ga', ...
    'PopulationSize', min(200, 10*nvars), ... % 自适应种群大小
    'MaxGenerations', 200, ...
    'FunctionTolerance', 1e-6, ...
    'ConstraintTolerance', 1e-3, ...
    'CrossoverFraction', 0.8, ...
    'MutationFcn', @mutationadaptfeasible, ...
    'CrossoverFcn', @crossoverintermediate, ...
    'SelectionFcn', @selectiontournament, ...
    'Display', 'iter', ...
    'PlotFcn', {@gaplotbestf, @gaplotstopping}, ...
    'UseParallel', true);


% % 合并用户自定义选项
% if ~isempty(p.Results.options)
%     options = optimoptions(defaultOptions, p.Results.options);
% else
     options = defaultOptions;
% end

%% 运行遗传算法
[x_opt, fval, exitflag, output] = ga(...
    p.Results.fun, ...    % 目标函数
    p.Results.nvars, ...  % 变量个数
    p.Results.A, ...      % 线性不等式约束A
    p.Results.b, ...      % 线性不等式约束b
    p.Results.Aeq, ...    % 线性等式约束Aeq
    p.Results.beq, ...    % 线性等式约束beq
    p.Results.lb, ...     % 变量下界
    p.Results.ub, ...     % 变量上界
    p.Results.nonlcon, ... % 非线性约束
    options);             % 算法选项

%% 结果显示
fprintf('\n=== 优化结果 ===\n');
fprintf('最优解: [');
fprintf('%.6g ', x_opt);
fprintf(']\n');
fprintf('最优函数值: %.6g\n', fval);
fprintf('退出条件: %d (%s)\n', exitflag, getExitFlagMessage(exitflag));
fprintf('迭代次数: %d\n', output.generations);
fprintf('函数评估次数: %d\n', output.funccount);

%% 辅助函数：退出标志解释
    function msg = getExitFlagMessage(flag)
        switch flag
            case 1, msg = '适应度值变化小于FunctionTolerance';
            case 3, msg = '适应度值变化小于ConstraintTolerance';
            case 4, msg = '达到最大迭代次数';
            case 5, msg = '达到最大时间限制';
            case 0, msg = '达到最大函数评估次数';
            case -1, msg = '由输出函数或绘图函数终止';
            case -2, msg = '无可行解';
            case -4, msg = '线性约束不一致';
            case -5, msg = '线性等式约束不一致';
            otherwise, msg = '未知退出标志';
        end
    end
end