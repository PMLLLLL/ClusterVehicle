function [SS,SD,DS,DD] = GetSS_SD_DS_DD(true_labels, cluster_labels)
    N = length(true_labels);

    % 计算 TP, TN, FP, FN
    SS = 0; SD = 0; DS = 0; DD = 0;

    for i = 1:N
        for j = i+1:N
            if(Getabcd(true_labels(i),true_labels(j),cluster_labels(i),cluster_labels(j))==1)
                SS = SS + 1;
            elseif(Getabcd(true_labels(i),true_labels(j),cluster_labels(i),cluster_labels(j))==2)
                SD = SD + 1;
            elseif(Getabcd(true_labels(i),true_labels(j),cluster_labels(i),cluster_labels(j))==3)
                DS = DS + 1;
            elseif(Getabcd(true_labels(i),true_labels(j),cluster_labels(i),cluster_labels(j))==4)
                DD = DD + 1;
            end
        end
    end
end
