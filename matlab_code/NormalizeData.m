function reslut = NormalizeData(data)

        % 要处理的列 1 2 3列使用最大最小值归一化
        columns_to_process = [1,2,3];

        for idx = columns_to_process
            data(:,idx) = MaxMinNormalization(data(:,idx),min(data(:,idx)),max(data(:,idx)));
        end

        % % 第四列磁场使用分层归一化
        % DataMG(:, 4) = HierarchicalNormalization(DataMG(:, 4));

        % % 第四列磁场使用对数归一化
        % DataMG(:, 4) = LogNormalization(DataMG(:, 4));

        % 第四列磁场使用最大最小值归一化
        data(:, 4) = MaxMinNormalization(data(:, 4),min(data(:, 4)),max(data(:, 4)));
    
        reslut = data;
    end
