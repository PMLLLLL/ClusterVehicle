classdef DataProcessing
    %DATAPROCESSING 此处显示有关此类的摘要
    %   数据处理类
    
    properties
        dataIn;% 输入的数据
        normalizedData; % 排序并且归一化的数据
    end
    
    methods
        function obj = DataProcessing(datapath)
            %DATAPROCESSING 构造此类的实例
            %   读取数据并排序归一化
            obj.dataIn = readmatrix(datapath);
            obj = NormalizeData(obj);
        end
        
        function obj = NormalizeData(obj)
            DataMG = sortrows(obj.dataIn, 3); % 按照第三列（位置Y）从小到大排序

            % 数据归一化，与原始实现保持一致
            total_columns = size(DataMG, 2);
            % 要处理的列
            columns_to_process = [1, 3, 4];
        
            % 获取各列的最小值和最大值
            Mins = min(DataMG(:, columns_to_process), [], 1);  % 获取指定列的最小值
            Maxs = max(DataMG(:, columns_to_process), [], 1);  % 获取指定列的最大值
        
            % 对指定列进行处理
            for idx = columns_to_process  % 对第1, 3, 4列进行归一化
                % 排除NaN值
                if any(isnan(DataMG(:, idx)))
                   warning('Data contains NaN values in column %d, replacing with column mean.', idx);
                   % 用该列的均值替代NaN值
                  DataMG(:, idx) = fillmissing(DataMG(:, idx), 'constant', nanmean(DataMG(:, idx)));
                end
                
                % 获取该列的最小值和最大值（忽略NaN）
                Mins(idx) = min(DataMG(:, idx), [], 'omitnan');  % 忽略NaN值计算最小值
                Maxs(idx) = max(DataMG(:, idx), [], 'omitnan');  % 忽略NaN值计算最大值
                
                % 如果最大值与最小值不相等，进行归一化
                if Maxs(idx) > Mins(idx)
                   DataMG(:, idx) = (DataMG(:, idx) - Mins(idx)) / (Maxs(idx) - Mins(idx));
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
            % 
            % % 设置一个缩放因子来调整第二列的权重
            % weightFactor = 0.03;  % 假设缩放因子为0.05，表示第二列权重较小
            % scaledDiscreteData = discreteDataNormalized * weightFactor;  % 缩放后的第二列数据
        
            % 将处理后的第二列数据重新放回
            DataMG(:, 2) = discreteDataNormalized;
        
            obj.normalizedData = DataMG;
        end


    end
end

