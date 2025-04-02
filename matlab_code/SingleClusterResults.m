%% 聚类结果归一化结果可视化
% 创建一个新的图形窗口
figure;
hold on;
grid on;
view(3); % 设置三维视角

clustersNum = 55;

% 获取当前簇的所有数据点
ClusterData = CE.clusters(clustersNum).Data(:,1:3);
CenterData = CE.clusters(clustersNum).allCentre(:,1:3);
DirectionData = CE.clusters(clustersNum).allDirection(:,1:3);

length = size(ClusterData,1);

for i = 1 : length
    scatter3(ClusterData(i,1), ClusterData(i,2), ClusterData(i,3), ...
             20, GetColorByIndex(0),'filled');

    scatter3(CenterData(i,1), CenterData(i,2), CenterData(i,3), ...
             30, GetColorByIndex(1),'filled');

    quiver3(CenterData(i,1), CenterData(i,2), CenterData(i,3), ...
            DirectionData(i,1), DirectionData(i,2), DirectionData(i,3), ...
            0, 'LineWidth', 0.1, 'MaxHeadSize', 0.1,'Color',GetColorByIndex(2));
end

% 设置三维坐标轴标签
xlabel('位置归一化');
ylabel('车道归一化');
zlabel('时间归一化');

% 设置标题和显示配置
title('聚类结果归一化结果可视化');
hold off;