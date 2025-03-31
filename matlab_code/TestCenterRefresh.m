% 中心更新测试代码
clear all;

function results = DeNormal_MaxMinNormal(data,min,max)
    results = data*(max-min) + min;
end

dataIn = readmatrix('../2025.3.29 一辆没换道的车.xlsx');
num = length(dataIn(:,1));

min3 = min(dataIn(:,3));
max3 = max(dataIn(:,3));
min1 = min(dataIn(:,1));
max1 = max(dataIn(:,1));

dataIn(:,3) = MaxMinNormal(dataIn(:,3),min3,max3);
dataIn(:,1) = MaxMinNormal(dataIn(:,1),min1,max1);

%% 聚类结果归一化结果可视化
% 创建一个新的图形窗口
figure(1);
hold on;
grid on;
view(3); % 设置三维视图

% 获取当前簇的所有数据点
ClusterData = dataIn(:,1:3);
length = size(ClusterData,1);
preValue = zeros(length-2,3);

for i = 1 : length
    scatter3(ClusterData(i,1), ClusterData(i,2), ClusterData(i,3), ...
             20, 'red','filled');

    if(i < length-1)
        oA = ClusterData(i,1:3);
        oB = ClusterData(i+1,1:3);
        n = ClusterData(i+1,1)-ClusterData(i,1);
    
        preValue(i,:) = (oB-oA)/(oB(1)-oA(1))*(ClusterData(i+2,1)-oB(1))+oB;
    
        scatter3(preValue(i,1), preValue(i,2), preValue(i,3), ...
                 30, 'blue','filled');
    end
end

% 设置三维坐标轴标签
xlabel('位置归一化');
ylabel('车道归一化');
zlabel('时间归一化');

% 设置标题和显示配置
title('聚类结果归一化结果可视化');
axis equal; % 设置坐标轴等比例显示
hold off;

%% 聚类结果反归一化结果可视化
% 创建一个新的图形窗口
figure(2);
hold on;
grid on;
view(3); % 设置三维视图
DeNormal_ClusterData = ClusterData;
DeNormal_preValue = preValue;

DeNormal_ClusterData(:,1) = DeNormal_MaxMinNormal(ClusterData(:,1),min1,max1);
DeNormal_ClusterData(:,3) = DeNormal_MaxMinNormal(ClusterData(:,3),min3,max3);

DeNormal_preValue(:,1) = DeNormal_MaxMinNormal(preValue(:,1),min1,max1);
DeNormal_preValue(:,3) = DeNormal_MaxMinNormal(preValue(:,3),min3,max3);


for i = 1 : length
    scatter3(DeNormal_ClusterData(i,1), DeNormal_ClusterData(i,2), DeNormal_ClusterData(i,3), ...
             20, 'red','filled');
    if(i < length-1)
        scatter3(DeNormal_preValue(i,1), DeNormal_preValue(i,2), DeNormal_preValue(i,3), ...
                 30, 'blue','filled');
    end
end

% 设置三维坐标轴标签
xlabel('位置归一化');
ylabel('车道归一化');
zlabel('时间归一化');

% 设置标题和显示配置
title('聚类结果归一化结果可视化');
hold off;

for i = 1:48
    error(i) = EuclideanDistance(preValue(i,:),ClusterData(i+2,:));
end

figure(3)
plot(error);







