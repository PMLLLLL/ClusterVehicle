% 时间序列交叉验证
clear;

path = '../2025.2.27 大车小车数据合并_真实标签.xlsx';
DataOper = DataProcessing(path);

TimeSeriesAll = length(DataOper.normalizedData(:,1));
TimeSeriesTrainStar = TimeSeriesAll/4;% 第一个训练集从1-总数量的1/4
TimeSeriesTrainEnd = 3*TimeSeriesAll/4;% 滚动到3/4

for i = TimeSeriesTrainStar:TimeSeriesTrainEnd
    ClusterAndBaySopt()

end

