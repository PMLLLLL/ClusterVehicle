function results = HierarchicalNormalization(data)
    % 分层归一化函数
    Hierarchical = [1000,5000;
                    375, 1000;
                    0, 375];
    results = zeros(size(data));
    t = length(Hierarchical(:,1));

    for i = 1:t
        % 分层逻辑索引
        mask = (data >= Hierarchical(i,1)) & (data < Hierarchical(i,2));
        results(mask) =3-i + (data(mask) - Hierarchical(i,1)) / (Hierarchical(i,2) - Hierarchical(i,1));
    end

    results = (results - min(results))/(max(results) - min(results));
end