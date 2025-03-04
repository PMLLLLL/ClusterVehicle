classdef Visualize

    properties(Access = public)
        Clusters;
        trueLabels;
        clusterLabels;
        ContingencyMatrix;
    end

    methods(Access = public)
        % 构造函数
        function obj = Visualize(Cluster)
            obj.Clusters = Cluster;

            dataLabeled = [];

            for j = 1:length(obj.Clusters)
                obj.Clusters(j).Data(:,6) = j;
                dataLabeled = [dataLabeled;obj.Clusters(j).Data()];
            end

            % 提取真实分类的标签
            obj.trueLabels = dataLabeled(:,5)';
            obj.clusterLabels = dataLabeled(:,6)';

            %计算混淆矩阵
            obj.ContingencyMatrix = Contingency(obj);
        end

        % 显示聚类结果的图
        function ClustersImg(obj)
            % 创建一个新的图形窗口
            figure;
            hold on;
            grid on;
            view(3); % 设置三维视图
        
            % 获取所有簇的中心
            allCentres = arrayfun(@(c) c.Centre, obj.Clusters, 'UniformOutput', false);  % 返回所有簇中心
            numClusters = size(allCentres, 2);  % 获取簇数量
        
            % 定义颜色表
            Clrs = lines(numClusters); % 使用默认的线条颜色方案
        
            % 绘制每个簇
            for idx2 = 1:numClusters
            % 获取当前簇的中心
            clusterCentre = obj.Clusters(idx2).Centre;
        
            % 为当前簇选择颜色
            clusterColor = Clrs(idx2, :);
                
            % 获取当前簇的所有数据点
            ClusterData = obj.Clusters(idx2).Data;
            length = size(ClusterData,1);
                
                for idx3 = 1 : length
                    % 获取簇中的每个数据点
                    data = ClusterData(idx3, :);
            
                    % 车道数据缩小显示
                    data(2) = data(2)*0.03;
                        
                    % 绘制当前簇的前三维数据点
                    scatter3(data(1), data(2), data(3), ...
                             20, clusterColor, 'filled');
                end
        
        
                % 设置三维坐标轴标签
                xlabel('位置归一化');
                ylabel('车道归一化');
                zlabel('时间归一化');
            end
        
            % 设置标题和显示配置
            title('聚类结果可视化');
            axis equal; % 设置坐标轴等比例显示
            hold off;
        end

        % 绘制混淆矩阵图1
        function ContingencyHeatMap1(obj)
            % 使用 confusionchart 绘制混淆矩阵
            figure;
            heatmap(obj.ContingencyMatrix);
            title('Confusion Matrix Heatmap');
        end

        % 绘制混淆矩阵图2
        function ContingencyHeatMap2(obj)
            % 创建热图
            figure;
            imagesc(obj.ContingencyMatrix); % 绘制热图
            colorbar;    % 显示颜色条
            axis equal;  % 保持坐标轴比例
            xlabel('Predicted');
            ylabel('True');
            title('Confusion Matrix');
            colormap(parula(10)); % 设置颜色
        end

        function [contingencyMatrix] = Contingency(obj)
            % 计算混淆矩阵
            n = length(obj.trueLabels);
            uniqueTrueLabels = unique(obj.trueLabels); % 真实标签的唯一值
            uniquePredLabels = unique(obj.clusterLabels); % 预测标签的唯一值
            contingencyMatrix = zeros(length(uniqueTrueLabels), length(uniquePredLabels)); % 初始化混淆矩阵
            
            % 遍历样本，填充混淆矩阵
            for i = 1:n
                trueIdx = find(uniqueTrueLabels == obj.trueLabels(i));   % 找到真实标签的索引
                predIdx = find(uniquePredLabels == obj.clusterLabels(i));   % 找到预测标签的索引
                contingencyMatrix(trueIdx, predIdx) = contingencyMatrix(trueIdx, predIdx) + 1;
            end
        end

    end
end