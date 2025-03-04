classdef GenerateWeights

    properties(Access = public)
        stepSize;
    end

    methods(Access = public)
        % 构造函数
        function obj = GenerateWeights(stepsize)
            obj.stepSize = stepsize;
        end

        % 产生按百分比变化的权重 其他权重的占比相同
        % weighttotalnum 总共有几个权重
        % weightnum 选择哪个权重按百分比变化
        function [weights,count] = Percentage(obj,weighttotalnum,weightnum)
            
            iVals = 0:obj.stepSize:100; % 生成 i 的所有取值
            mainVals = iVals / 100;
            remainVals = (100 - iVals) / (weighttotalnum-1) / 100;
        
            % 组合矩阵
            weights = repmat(remainVals', 1, weighttotalnum);
            weights(:,weightnum) = mainVals';
        
            count = length(iVals);
        end

        % 遍历的权重 
        % weighttotalnum 总共有几个权重
        % weightnum 选择哪个权重按百分比变化
        function [weights,count] = Traverse(obj)
         
            count = 0;
            weights = [];
            % 遍历所有权重组合
            for w1 = 0.1:obj.stepSize:1
                for w2 = 0.1:obj.stepSize:(1 - w1)  % w2的范围受w1影响
                    for w3 = 0.1:obj.stepSize:(1 - w1 - w2)  % w3的范围受w1, w2影响
                        w4 = 1 - w1 - w2 - w3;  % 通过w4来保证权重之和为1
                        if w4 >= 0  % 保证w4为非负值
                            weights = [weights; w1, w2, w3, w4];  % 将每一组组合存储起来
                            count = count + 1;
                        end
                    end
                end
            end

        end

    end
end