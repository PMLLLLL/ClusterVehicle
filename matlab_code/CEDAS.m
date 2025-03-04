classdef CEDAS

    properties(Access = public)
        clusters;
        initDirection;
        rad;
        decay;
        weights;
    end

    methods(Access = public)
        function obj = CEDAS(rad, decay,weights, initDirection)
           % 新建类，将簇初始化 初始长度为0
           obj.clusters = struct('Data', {}, 'Centre', {}, 'Life', {}, 'Direction', {});
           obj.rad = rad;
           obj.decay = decay;
           obj.weights = weights;
           obj.initDirection = initDirection;
        end

        function obj = Clustering(obj,sample)
            % 如果是没有簇，则创建一个新簇
            if(isempty(obj.clusters)) 
                obj = obj.InitNewCluster(sample);
                return;
            end

            % 计算当前数据与所有簇中心的加权距离，并筛选可关联的簇
            numClusters = length(obj.clusters);
            distances = inf(1, numClusters); % 预分配 distances 为无穷远
            validClusters = false(1, numClusters); % 预分配逻辑索引数组
 
            % 遍历所有簇
            for i = 1:numClusters
                if max(obj.clusters(i).Data(:, 1)) < sample(1) % % 取簇的第一列数据筛选符合条件的簇
                    % 计算加权欧几里得距离
                    distances(i) = sqrt(sum((obj.weights(1:4) .* (sample(1:4) - obj.clusters(i).Centre(1:4))).^2));
                    validClusters(i) = distances(i) < obj.rad; % 记录满足距离条件的簇
                end
            end
            
            % 提取有效簇索引
            validClusters = find(validClusters);
            
            % 如果没有满足条件的簇，则创建新簇
            if isempty(validClusters)
                obj = obj.InitNewCluster(sample);
                return;
            end
            
            % 根据方向性和距离计算收益，并选择最佳匹配簇
            bestScore = -inf;
            bestClusterIdx = -1;
            
            sampleDirection = sample(1:3); % 仅取前三维用于方向计算
            
            for i = validClusters
                % 计算方向性匹配度
                direction_vector = sampleDirection - obj.clusters(i).Centre(1:3);
                dirNorm = norm(direction_vector);
                
                CosSim = dot(direction_vector, obj.clusters(i).Direction) / (dirNorm * norm(obj.clusters(i).Direction));
                
                % 归一化距离
                NormDist = distances(i) / obj.rad;
                
                % 计算收益
                score = 0.2 * (1 - NormDist) + 0.8 * CosSim;
                
                % 更新最佳簇索引
                if score > bestScore
                    bestScore = score;
                    bestClusterIdx = i;
                end
            end
            
            % 选择最佳簇或创建新簇
            if bestScore > 0.3
                obj = obj.AssignToCluster(bestClusterIdx, sample);
            else
                obj = obj.InitNewCluster(sample);
            end
            
            % % 衰减簇生命值并移除失效簇
            % obj.clusters(:).Life = [obj.clusters(:).Life] - obj.decay;
            % index = find([obj.clusters(:).Life] <= 0);
            % obj.clusters(index) = [];

            % 衰减簇生命值
            for i = 1:length(obj.clusters) % 倒序遍历以便移除
                obj.clusters(i).Life = obj.clusters(i).Life - obj.decay;
            end

            % 移除失效簇
            index = find([obj.clusters(:).Life] <= 0);
            obj.clusters(index) = [];
        end

        % 初始化新簇
        function obj = InitNewCluster(obj,newSample)
            newCluster.Data = newSample;            % 新簇中仅包含当前数据
            newCluster.Centre = newSample;          % 簇中心初始为当前数据
            newCluster.Life = 1;                    % 初始生命周期
            newCluster.Direction = obj.initDirection / sqrt(3); % 初始方向为均匀向量 应该不给车道号权重
            obj.clusters = [obj.clusters, newCluster];
        end

        % 将新数据分配到现有簇
        function obj = AssignToCluster(obj,clusterIndex,newSample)
            % 分配数据到现有簇
            obj.clusters(clusterIndex).Data = [obj.clusters(clusterIndex).Data; newSample]; % 加入新点
            obj.clusters(clusterIndex).Life = 1; % 重置生命值
        
            % 更新簇中心
            direction = (newSample(1:3) - obj.clusters(clusterIndex).Centre(1:3)) / obj.rad;
            obj.clusters(clusterIndex).Centre(1:3) = obj.clusters(clusterIndex).Centre(1:3) + 0.1 * direction; %增加新加入的权重
        
            % 更新磁场值
            obj.clusters(clusterIndex).Centre(4) = mean([obj.clusters(clusterIndex).Centre(4) newSample(4)]);
        
            % 更新方向性
            obj = UpdateClusterDirection(obj,clusterIndex, newSample);
        end

        % 更新簇的方向性
        function obj = UpdateClusterDirection(obj, clusterIndex,newSample)
            % 使用当前簇方向和新样本的方向加权更新
            direction = newSample(1:3) - obj.clusters(clusterIndex).Centre(1:3);
            newDirection = 0.5 * obj.clusters(clusterIndex).Direction + 0.5 * (direction / norm(direction));
            obj.clusters(clusterIndex).Direction = newDirection / norm(newDirection); % 归一化
        end
    end
end