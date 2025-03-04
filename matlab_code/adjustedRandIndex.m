function ARI = adjustedRandIndex(trueLabels, predLabels)
    % trueLabels: 真实标签
    % predLabels: 聚类结果标签

    % 样本数量
    n = length(trueLabels);
    
    % 计算真实标签和聚类标签的混淆矩阵
    % contingency matrix
    [ct] = contingency(trueLabels, predLabels);
    
    % 计算每行（真实类别）的和
    rowSum = sum(ct, 2);
    
    % 计算每列（聚类类别）的和
    colSum = sum(ct, 1);
    
    % 计算样本对总数
    nChoose2 = n * (n - 1) / 2;
    
    % 计算实际的 Rand Index (RI)
    RI = 0;
    for i = 1:n
        for j = 1:n
            if trueLabels(i) == trueLabels(j) && predLabels(i) == predLabels(j)
                RI = RI + 1;  % 同一类且预测一致
            elseif trueLabels(i) ~= trueLabels(j) && predLabels(i) ~= predLabels(j)
                RI = RI + 1;  % 不同类且预测一致
            end
        end
    end
    
    % 计算期望的 Rand Index (E[RI])
    E_RI = 0;
    for i = 1:n
        for j = 1:n
            if trueLabels(i) == trueLabels(j) && predLabels(i) ~= predLabels(j)
                E_RI = E_RI + 1;
            end
        end
    end
    
    % 计算 ARI
    ARI = (RI - E_RI) / (nChoose2 - E_RI);
    
end

