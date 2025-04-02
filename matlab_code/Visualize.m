classdef Visualize

    properties(Access = public)
        Clusters;
        trueLabels;
        clusterLabels;
        ContingencyMatrix;
    end

    methods(Access = public)
        % 构造函数
        function obj = Visualize(Cluster,trueLabels,clusterLabels,ContingencyMatrix)
            obj.Clusters = Cluster;
            obj.trueLabels = trueLabels;
            obj.clusterLabels = clusterLabels;
            %计算混淆矩阵
            obj.ContingencyMatrix = ContingencyMatrix;
        end

        % 显示聚类结果的图
        function ClustersImg(obj)
            % 创建一个新的图形窗口
            figure;
            hold on;
            grid on;
            view([-75.8182 5.3748]); % 设置三维视图
            
            numClusters = size(obj.Clusters,2);  % 获取簇数量
        
        
            % 绘制每个簇
            for idx2 = 1:numClusters

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
                             20, obj.Clusters(idx2).Color, 'filled');
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
    end
end