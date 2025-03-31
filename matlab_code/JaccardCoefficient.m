function JC = JaccardCoefficient(SS,SD,DS)
    % 计算 Jaccard Coefficient
    JC = SS / (SS+SD+DS);
end
