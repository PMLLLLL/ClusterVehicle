function FMI = TargetFunc(weight1,weight2,weight3,weight4,initDirection1,initDirection2,initDirection3, ...
                        refreshDirWei1,refreshDirWei2,scoreWei1,scoreWei2,centerWei1,centerWei2,rad,path,trainIdx)

% 参数设置
decay = 0.000001; % 衰减因子

weights = [weight1,weight2,weight3,weight4];
initDirection = [initDirection1,initDirection2,initDirection3];
refreshDirWei = [refreshDirWei1,refreshDirWei2];
scoreWei = [scoreWei1,scoreWei2];
centerWei = [centerWei1,centerWei2];

DataOper = DataProcessing(path);

CE = CEDAS(rad, decay,weights, initDirection,refreshDirWei,scoreWei,centerWei); % 用于存储聚类结果

for t = 1:size(DataOper.normalizedData, 1)
    % 调用 CEDAS_demo3 算法
    CE = CE.Clustering(DataOper.normalizedData(t,:));
end

% 计算真实标签和混淆矩阵
DataOper = DataOper.GetLabel(CE.clusters);

% 计算分类准确度RI
[RI JC FMI] = GetRI_JC_FMI(DataOper.trueLabels,DataOper.clusterLabels);
FMI = -FMI;

end