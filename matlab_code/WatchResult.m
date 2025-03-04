clusters = []; % 用于存储聚类结果
dataLabeled = [];

for t = 1:size(NormalizedData, 1)
    % 调用 CEDAS_demo3 算法
    [clusters] = CEDAS_NoWeightChange(NormalizedData(t, :), clusters, 0.35, 0.01, ...
                                      MaxDistThreshold,  [0.3 0.4 0.2 0.1 ], alpha, beta, learningRate, [1 0 1]);
end
% 输出聚类结果


% 提取聚类的分类结果标签
for j = 1:length(clusters)
    clusters(j).Data(:,6) = j;
    dataLabeled = [dataLabeled;clusters(j).Data()];
end

% RIMax = max(RIMax,rand_index(trueLabels,clusterLabels));

% 可视化
show = Visualize(clusters);
show.ContingencyHeatMap1();
show.ContingencyHeatMap2();
show.ClustersImg;
% 计算分类准确度RI
RI = RandIndex(show.trueLabels,show.clusterLabels);

%if(RandIndex(show.trueLabels,show.clusterLabels) <= RIMax)
% RIMax = RandIndex(show.trueLabels,show.clusterLabels);
fprintf(['第%d次聚类结果的数量: %d 权重Weights = [%s] RI' ...
        '' ...
        ' = %s \n'],...
        1,length(clusters),sprintf('%.2f ', [0.30 0.30 0.30 0.10 ]),sprintf('%.4f ', RI));
%end