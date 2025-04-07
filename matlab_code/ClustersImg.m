function ClustersImg(Clusters)
    % 绘制聚类的结果
    figure;
    hold on;
    grid on;
    view([-75.8182 5.3748]); % 设置三维视图
    
    numClusters = size(Clusters,2);  % 获取簇数量


    % 绘制每个簇
    for idx2 = 1:numClusters

    % 获取当前簇的所有数据点
    ClusterData = Clusters(idx2).Data;
    length = size(ClusterData,1);
        
        for idx3 = 1 : length
            % 获取簇中的每个数据点
            data = ClusterData(idx3, :);
    
            % 车道数据缩小显示
            data(2) = data(2)*0.03;
                
            % 绘制当前簇的前三维数据点
            scatter3(data(1), data(2), data(3), ...
                     20, Clusters(idx2).Color, 'filled');
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