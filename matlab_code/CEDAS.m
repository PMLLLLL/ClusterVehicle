classdef CEDAS

    properties(Access = public)
        clusters;
        initDirection;
        rad;
        decay;
        weights;
        refreshDirWei;
        scoreWei;
        centerWei;
    end

    methods(Access = public)
        function obj = CEDAS(rad, decay,weights,initDirection,refreshdirWei,scorewei,centerwei)
           % 新建类，将簇初始化 初始长度为0
           obj.clusters = struct('Data', {}, 'Centre', {}, 'Life', {}, 'Direction', {});
           obj.rad = rad;
           obj.decay = decay;
           obj.weights = weights;
           obj.initDirection = initDirection;
           obj.refreshDirWei = refreshdirWei;
           obj.scoreWei = scorewei;
           obj.centerWei = centerwei;
        end

        function obj = Clustering(obj,sample,logtext)
            % 如果是没有簇，则创建一个新簇
            if(isempty(obj.clusters)) 
                obj = obj.InitNewCluster(sample);
                % fprintf(logtext, '没有数据 建立第一个簇\n'); % 写入日志文件
                return;
            end

            % 计算当前数据与所有簇中心的加权距离，并筛选可关联的簇
            numClusters = length(obj.clusters);
            distances = inf(1, numClusters); % 预分配 distances 为无穷远
            validClusters = false(1, numClusters); % 预分配逻辑索引数组
 
            % 遍历所有簇
            % fprintf(logtext, '此时簇的个数为%d个,对簇距离进行遍历: ',numClusters); % 写入日志文件
            for i = 1:numClusters
                if max(obj.clusters(i).Data(:, 1)) < sample(1) % % 取簇的第一列数据筛选符合条件的簇
                    % 计算加权欧几里得距离
                    distances(i) = sqrt(sum((obj.weights(1:4) .* (sample(1:4) - obj.clusters(i).Centre(1:4))).^2));
                    % fprintf(logtext, '与第%d个簇的距离为%.2f ',i,distances(i)); % 写入日志文件每次计算簇的距离
                    validClusters(i) = distances(i) < obj.rad; % 记录满足距离条件的簇
                else
                    % fprintf(logtext, '第%d个簇第一列数据不满足要求 ',i); % 写入日志文件每次计算簇的距离
                end
        
            end
            
            % 提取有效簇索引
            validClusters = find(validClusters);
            
            % 如果没有满足条件的簇，则创建新簇
            if isempty(validClusters)
                obj = obj.InitNewCluster(sample);
                % fprintf(logtext, '与所有簇的距离都大于聚类半径，创建新簇/n'); % 写入日志文件每次计算簇的距离
                return;
            end
            
            % 根据方向性和距离计算收益，并选择最佳匹配簇
            bestScore = -inf;
            bestClusterIdx = -1;
            
            sampleDirection = sample(1:3); % 仅取前三维用于方向计算
            
            % fprintf(logtext, '对聚类半径之内的簇计算收益 '); % 写入日志文件每次计算簇的距离
            for i = validClusters
                % 计算方向性匹配度
                direction_vector = sampleDirection - obj.clusters(i).Centre(1:3);
                dirNorm = norm(direction_vector);
                
                CosSim = dot(direction_vector, obj.clusters(i).Direction) / (dirNorm * norm(obj.clusters(i).Direction));
                
                % 归一化距离
                NormDist = distances(i) / obj.rad;

                % fprintf(logtext, '第%d个簇方向为%.2f ',i,CosSim);
                
                % 计算收益
                score = obj.scoreWei(1) * (1 - NormDist) + obj.scoreWei(2) * CosSim;
                % fprintf(logtext, '计算得到的收益为%.2f',score); % 写入日志文件每次计算簇的距离
                % 更新最佳簇索引
                if score > bestScore
                    bestScore = score;
                    bestClusterIdx = i;
                end
            end
            
            % 选择最佳簇或创建新簇
            if bestScore > 0.3
                obj = obj.AssignToCluster(bestClusterIdx, sample);
                % fprintf(logtext, '收益最佳的簇为第%d个,且得分为%.2f,将数据加入到第%d个簇',bestClusterIdx,bestScore,bestClusterIdx); % 写入日志文件每次计算簇的距离
            else
                obj = obj.InitNewCluster(sample);
                % fprintf(logtext, '所有得分没有超过0.3,形成新簇'); % 写入日志文件每次计算簇的距离
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
            % fprintf(logtext, '\n'); % 写入日志文件
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
            obj.clusters(clusterIndex).Centre(1:3) = obj.centerWei(1) * obj.clusters(clusterIndex).Centre(1:3) + obj.centerWei(2) * direction; %增加新加入的权重
        
            % 更新磁场值
            obj.clusters(clusterIndex).Centre(4) = mean([obj.clusters(clusterIndex).Centre(4) newSample(4)]);
        
            % 更新方向性
            obj = UpdateClusterDirection(obj,clusterIndex, newSample);
        end

        % 更新簇的方向性
        function obj = UpdateClusterDirection(obj, clusterIndex,newSample)
            % 使用当前簇方向和新样本的方向加权更新
            direction = newSample(1:3) - obj.clusters(clusterIndex).Centre(1:3);
            newDirection = obj.refreshDirWei(1) * obj.clusters(clusterIndex).Direction + obj.refreshDirWei(2) * (direction / norm(direction));
            obj.clusters(clusterIndex).Direction = newDirection / norm(newDirection); % 归一化
        end
    end
end