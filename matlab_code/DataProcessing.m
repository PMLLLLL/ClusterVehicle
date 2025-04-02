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
                obj.trueLabels = [obj.trueLabels Clusters(j).Data(:,5)'];
                % 第几个聚类代表分到第几个类别
                obj.clusterLabels = [obj.clusterLabels repmat(j, 1, length(Clusters(j).Data(:,5)))];
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

            % 要处理的列 1 2 3列使用最大最小值归一化
            columns_to_process = [1,2,3];

            for idx = columns_to_process
                DataMG(:,idx) = MaxMinNormalization(DataMG(:,idx),min(DataMG(:,idx)),max(DataMG(:,idx)));
            end

            % % 第四列磁场使用分层归一化
            % DataMG(:, 4) = HierarchicalNormalization(DataMG(:, 4));

            % % 第四列磁场使用对数归一化
            % DataMG(:, 4) = LogNormalization(DataMG(:, 4));

            % 第四列磁场使用最大最小值归一化
            DataMG(:, 4) = MaxMinNormalization(DataMG(:, 4),min(DataMG(:, 4)),max(DataMG(:, 4)));
        
            obj.normalizedData = DataMG;
        end

    end
end

