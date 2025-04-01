function results = LogNormalization(data)
    % 对数归一化函数
    data = log(data);
    results = MaxMinNormalization(data,min(data),max(data));
end