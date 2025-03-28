classdef DataProcessing
    %DATAPROCESSING 此处显示有关此类的摘要
    %   数据处理类
    
    properties
        dataIn;% 输入的数据
        normalizedData; % 排序并且归一化的数据
        trueLabels;% 聚类结果后的真实标签
        clusterLabels;% 聚类结果之后的预测标签
        contingencyMatrix;%混淆矩阵
        dataLabeled;%结果数据汇总
        dataToExcel;%结果数据汇总

        % 归一化的参数
        Mins;
        Maxs;
    end
    
    methods
        function obj = DataProcessing(datapath,trainIdx)
            %DATAPROCESSING 构造此类的实例
            %   读取数据并排序归一化

            if nargin > 1
                obj.dataIn = readmatrix(datapath);
                obj.dataIn = obj.dataIn(trainIdx,:);
                obj = NormalizeData(obj);
            end
            if nargin == 1
                obj.dataIn = readmatrix(datapath);
                obj = NormalizeData(obj);
            end
        end

        % 获取真实和聚类结果标签
        function obj = GetLabel(obj,Clusters)
            obj.trueLabels = [];
            obj.clusterLabels = [];

            for j = 1:length(Clusters)
                %数据第五列存储着真实标签
                % obj.trueLabels = [obj.trueLabels Clusters(j).Data(:,5)'];
                % 第几个聚类代表分到第几个类别
                % obj.clusterLabels = [obj.clusterLabels repmat(j, 1, length(Clusters(j).Data(:,5)))];
            end

        end

        % 将聚类结果输出到excel中
        function Output2Excel(obj,filename,Clusters)
            obj.dataLabeled = [];

            for j = 1:length(Clusters)
                Clusters(j).Data(:,6) = j;
                Clusters(j).Data(:,7) =  Clusters(j).Data(:,1)*(obj.Maxs(1)-obj.Mins(1)) + obj.Mins(1);
                Clusters(j).Data(:,8) =  Clusters(j).Data(:,2)+1;
                Clusters(j).Data(:,9) =  Clusters(j).Data(:,3)*(obj.Maxs(3)-obj.Mins(3)) + obj.Mins(3);
                Clusters(j).Data(:,10) =  Clusters(j).Data(:,4)*(obj.Maxs(4)-obj.Mins(4)) + obj.Mins(4);
                obj.dataLabeled = [obj.dataLabeled;Clusters(j).Data()];
            end

            writematrix(obj.dataLabeled, filename); % 将矩阵写入 Excel 文件

        end

        % 计算混淆矩阵
        function obj = GetContingencyMatrix(obj)
            % 计算混淆矩阵
            n = length(obj.trueLabels);
            uniqueTrueLabels = unique(obj.trueLabels); % 真实标签的唯一值
            uniquePredLabels = unique(obj.clusterLabels); % 预测标签的唯一值
            contingencymatrix = zeros(length(uniqueTrueLabels), length(uniquePredLabels)); % 初始化混淆矩阵
            
            % 遍历样本，填充混淆矩阵
            for i = 1:n
                trueIdx = find(uniqueTrueLabels == obj.trueLabels(i));   % 找到真实标签的索引
                predIdx = find(uniquePredLabels == obj.clusterLabels(i));   % 找到预测标签的索引
                contingencymatrix(trueIdx, predIdx) = contingencymatrix(trueIdx, predIdx) + 1;
            end
            obj.contingencyMatrix = contingencymatrix;
        end

        % 数据归一化
        function obj = NormalizeData(obj)
            DataMG = sortrows(obj.dataIn, 3); % 按照第三列（位置Y）从小到大排序

            % 要处理的列 1 3列使用最大最小值归一化
            columns_to_process = [1, 3];
        
            % 获取各列的最小值和最大值
            obj.Mins = min(DataMG(:, columns_to_process), [], 1);  % 获取指定列的最小值
            obj.Maxs = max(DataMG(:, columns_to_process), [], 1);  % 获取指定列的最大值
        
            % 对指定列进行处理
            for idx = columns_to_process  % 对第1, 3列进行归一化
                % 排除NaN值
                if any(isnan(DataMG(:, idx)))
                   warning('Data contains NaN values in column %d, replacing with column mean.', idx);
                   % 用该列的均值替代NaN值
                  DataMG(:, idx) = fillmissing(DataMG(:, idx), 'constant', nanmean(DataMG(:, idx)));
                end
                
                % 获取该列的最小值和最大值（忽略NaN）
                obj.Mins(idx) = min(DataMG(:, idx), [], 'omitnan');  % 忽略NaN值计算最小值
                obj.Maxs(idx) = max(DataMG(:, idx), [], 'omitnan');  % 忽略NaN值计算最大值
                
                % 如果最大值与最小值不相等，进行归一化
                if obj.Maxs(idx) > obj.Mins(idx)
                   DataMG(:, idx) = (DataMG(:, idx) - obj.Mins(idx)) / (obj.Maxs(idx) - obj.Mins(idx));
                else
                   % 如果最大值与最小值相等，将该列置为0（可以根据需求修改）
                   DataMG(:, idx) = zeros(size(DataMG, 1), 1);  % 全部设置为零
                   disp(['Column ' num2str(idx) ' has constant values, setting to zero.']);
                end
            end
            % 第二列是离散值，间隔为4m，需要通过缩放因子来调整其权重
            discreteData = DataMG(:, 2);  % 获取第二列数据
            % 归一化第二列数据，假设其值在0和1之间
            discreteDataNormalized = (discreteData - min(discreteData)) / (max(discreteData) - min(discreteData));

            % 将处理后的第二列数据重新放回
            DataMG(:, 2) = discreteDataNormalized;

            % % 第四列磁场使用分层归一化
            Hierarchical = [1000,5000;
                            375, 1000;
                            0, 375];

            data = DataMG(:, 4);
            results = zeros(size(DataMG(:, 4)));
            t = length(Hierarchical(:,1));

            for i = 1:t
                % 分层逻辑索引
                mask = (data >= Hierarchical(i,1)) & (data < Hierarchical(i,2));
                results(mask) =3-i + (data(mask) - Hierarchical(i,1)) / (Hierarchical(i,2) - Hierarchical(i,1));
            end

            results = (results - min(results))/(max(results) - min(results));

            DataMG(:, 4) = results;%将归一化好的磁场值放回
        
            obj.normalizedData = DataMG;
        end

    end
end

