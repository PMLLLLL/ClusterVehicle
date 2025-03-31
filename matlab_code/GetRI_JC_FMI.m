function [RI,JC,FMI] = GetRI_JC_FMI(trueLables, clusterLables)
    [SS,SD,DS,DD] = GetSS_SD_DS_DD(trueLables,clusterLables);
    RI = RandIndex(SS,SD,DS,DD);
    JC = JaccardCoefficient(SS,SD,DS);
    FMI = FowlkesandMallowsIndex(SS,SD,DS);
end
