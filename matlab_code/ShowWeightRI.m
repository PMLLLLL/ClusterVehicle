clear;
clear functions;

% 参数设置
Rad = 0.35; % 聚类半径
Decay = 0.01; % 衰减因子
MaxDistThreshold = 2; % 最大距离阈值

% 初始权重
weights = [0.4, 0.4, 0.4, 0.4]; % 时间戳、位置、磁场值、车道号
learningRate = 0.01; % 学习率
alpha = 1; % 簇内距离权重
beta = 1;  % 簇间距离权重



% 数据加载与归一化
DataIn = readmatrix('../2025.2.25 大车数据合并_真实标签.xlsx'); % 读取文件数据 D:\1.project\2.融合组\code
%DataIn = readmatrix('D:/1.project/2.融合组/code/车辆赣C69900所在片段处理后加磁场.csv'); % 读取文件数据
DataIn = sortrows(DataIn, 3); % 按照第三列（位置Y）从小到大排序
NormalizedData = NormalizeData(DataIn);
% 产生遍历权重
generateWeights = GenerateWeights(0.1);
[weights,count] = generateWeights.Percentage(4,4);

RI = zeros(1,count);

% 聚类处理
for i = 1:count
    clusters = []; % 用于存储聚类结果
    dataLabeled = [];
    for t = 1:size(NormalizedData, 1)
        % 调用 CEDAS_demo3 算法
        [clusters] = CEDAS_NoWeight(NormalizedData(t, :), clusters, Rad, Decay, ...
                                          MaxDistThreshold, weights(i,:) , alpha, beta, learningRate);
    end
    

    % 提取聚类的分类结果标签
    for j = 1:length(clusters)
        clusters(j).Data(:,6) = j;
        dataLabeled = [dataLabeled;clusters(j).Data()];
    end

    show = Visualize(clusters);

    % 计算分类准确度RI
    RI(i) = RandIndex(show.trueLabels,show.clusterLabels);

    fprintf(['第%d次聚类结果的数量: %d 权重Weights = [%s] RI' ...
            '' ...
            ' = %s \n'],...
            i,length(clusters),sprintf('%.2f ', weights(i,:)),sprintf('%.4f ', RI(i)));
end

%画出变化趋势
plot(weights(:,4)',RI);





