% 数据加载与归一化
clear;
%DataIn = readmatrix('../2025.2.25 大车数据合并_真实标签.xlsx'); % 读取文件数据 D:\1.project\2.融合组\code
%DataIn = readmatrix('D:/1.project/2.融合组/code/车辆赣C69900所在片段处理后加磁场.csv'); % 读取文件数据
path = '../2025.3.3 85个数据汇总_标签.xlsx';
%DataIn = readmatrix('../2025.3.4 11-20个数据汇总_标签.xlsx');

% 数据真实标签放在第五列，并且同样的标签数据放在一起

NormalizedData = NormalizeData(readmatrix(path));

% 创建一个新的图形窗口
figure;
hold on;
grid on;
view([-75.8182 5.3748]); % 设置三维视图

% 绘制每个类
lable = NormalizedData(1,5);
classNum = 0;
Color = GetColorByIndex(classNum);
for i = 1:length(NormalizedData(:,5))
    if(lable ~= NormalizedData(i,5))
        % 分类数目加一
        classNum = classNum + 1;
        lable = NormalizedData(i,5);
        Color = GetColorByIndex(classNum);
    end
    % 绘制一个点
    data = NormalizedData(i,1:3);
    % 车道数据缩小显示
    data(2) = data(2)*0.03;
    % 绘制当前簇的前三维数据点
    scatter3(data(1), data(2), data(3), ...
             20, Color, 'filled');
end

% 设置三维坐标轴标签
xlabel('位置归一化');
ylabel('车道归一化');
zlabel('时间归一化');

% 设置标题和显示配置
title('聚类结果可视化');
axis equal; % 设置坐标轴等比例显示
hold off;