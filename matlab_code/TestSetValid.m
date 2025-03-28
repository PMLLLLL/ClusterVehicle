function RI = TestSetValid(path,rad,weights,initDirection,refreshDirWei,scoreWei,centerWei,testIdx)
    DataOper = DataProcessing(path,testIdx);
    
    CE = CEDAS(rad,0.000001,weights,initDirection,refreshDirWei,scoreWei,centerWei); % 用于存储聚类结果

    for t = 1:size(DataOper.normalizedData, 1)
        % 调用 CEDAS_demo3 算法
        CE = CE.Clustering(DataOper.normalizedData(t,:));
    end

    % 计算真实标签和混淆矩阵
    DataOper = DataOper.GetLabel(CE.clusters);
    
    % 计算分类准确度RI
    RI = -RandIndex(DataOper.trueLabels,DataOper.clusterLabels);
end
