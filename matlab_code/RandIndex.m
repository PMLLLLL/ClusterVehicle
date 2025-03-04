function RI = RandIndex(true_labels, cluster_labels)
    N = length(true_labels);

    % 计算 TP, TN, FP, FN
    TP = 0; FN = 0; FP = 0; TN = 0;

    for i = 1:N
        for j = i+1:N
            sameClusterTrue = (true_labels(i) == true_labels(j));
            sameClusterPred = (cluster_labels(i) == cluster_labels(j));

            if sameClusterTrue && sameClusterPred
                TP = TP + 1;
            elseif ~sameClusterTrue && ~sameClusterPred
                TN = TN + 1;
            elseif ~sameClusterTrue && sameClusterPred
                FP = FP + 1;
            elseif sameClusterTrue && ~sameClusterPred
                FN = FN + 1;
            end
        end
    end

    % 计算 Rand Index
    RI = (TP + TN) / (TP + TN + FP + FN);
end
