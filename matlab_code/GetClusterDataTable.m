function ClusterDataTable = GetClusterDataTable(Clusters)
    ClusterDataTable = [];
    for i = 1:length(Clusters)
        % 数据结果加上聚类的分配结果
        for j = 1:length(Clusters(i).Data(:,1))
            ClusterDataTable = [ClusterDataTable;Clusters(i).Data(j,:),i];
        end
    end
end