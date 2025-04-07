function reslut = NormalizeData(data,normalizemethodname)
    % 对数据1 2 3列使用归一化，第四列使用normalizemethodname方法归一化

    % 要处理的列 1 2 3列使用最大最小值归一化
    columns_to_process = [1,2,3];
    
    for idx = columns_to_process
        data(:,idx) = MaxMinNormalization(data(:,idx),min(data(:,idx)),max(data(:,idx)));
    end

    % 选用第四列磁场归一化的方案
    switch normalizemethodname  % 使用lower使匹配不区分大小写
        case 'HierarchicalNormalization'
            data(:, 4) = HierarchicalNormalization(data(:, 4));
        case 'LogNormalization'
            data(:, 4) = LogNormalization(data(:, 4));
        case 'MaxMinNormalization'
            data(:, 4) = MaxMinNormalization(data(:, 4),min(data(:, 4)),max(data(:, 4)));
        otherwise
            error('Unknown method: %s', methodName);
    end
    
    
    reslut = data;
end
