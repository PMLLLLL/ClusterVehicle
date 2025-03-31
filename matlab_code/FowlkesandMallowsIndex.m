function FMI = FowlkesandMallowsIndex(SS,SD,DS)
    % 计算 Fowlkesand Mallows Index
    FMI = sqrt((SS / (SS+SD))*(SS / (SS+DS)));
end
