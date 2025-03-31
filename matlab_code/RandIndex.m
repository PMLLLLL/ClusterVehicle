function RI = RandIndex(SS,SD,DS,DD)
    % 计算 Rand Index
    RI = (SS + DD) / (SS+SD+DS+DD);
end
