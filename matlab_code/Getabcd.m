function reslut = Getabcd(true_labels1,true_labels2, pre_labels1,pre_labels2)

    sameClusterTrue = (true_labels1 == true_labels2);
    sameClusterPred = (pre_labels1 == pre_labels2);

    % 1代表SS 2 SD 3 DS 4 DD
    if sameClusterTrue && sameClusterPred
        reslut = 1;
    elseif sameClusterTrue && ~sameClusterPred
        reslut = 2;
    elseif ~sameClusterTrue && sameClusterPred
        reslut = 3;
    elseif ~sameClusterTrue && ~sameClusterPred
        reslut = 4;
    end
end