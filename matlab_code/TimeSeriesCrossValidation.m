% % 时间序列交叉验证
% clear;
% 
% path = '../2025.2.27 大车小车数据合并_真实标签.xlsx';
% DataOper = DataProcessing(path);
% 
% TimeSeriesAll = length(DataOper.normalizedData(:,1));
% TimeSeriesTrainStar = TimeSeriesAll*4/5;% 第一个训练集从1-总数量的1/4
% TimeSeriesTrainEnd = TimeSeriesAll*7/8;% 滚动到3/4
% 
% 
% % 训练集使用聚类和贝叶斯优化
% for i = TimeSeriesTrainStar:TimeSeriesTrainEnd
% 
%     % 将从0-i的数据进行
%     ClusterAndBaySopt()
% 
% end

% 时间序列交叉验证
clear;

% 获取数据

path = '../2025.3.3 85个数据汇总_标签.xlsx';
DataOper = DataProcessing(path);

dataLength = length(DataOper.normalizedData(:,2));

disp(['数据长度:',num2str(dataLength)])

initialTrainSize = dataLength*0.5; % 初始训练集大小
intervalTrainSet = dataLength*0.01; % 每次训练集间隔大小

% 循环几次验证
maxFold = 12;

% 存储每次的性能指标
mse_values = zeros(maxFold,1);

for fold = 1:maxFold
    % 定义训练集索引
    trainEnd = round(initialTrainSize + (fold-1)*intervalTrainSet);
    trainIdx = 1:trainEnd;
    
    % 定义验证集索引 从训练集的后一位开始到最后
    testIdx = (trainEnd+1):dataLength;

    
    % 训练模型
    [trainRI,rad,weights,initDirection,refreshDirWei,scoreWei,centerWei] = ClusterAndBayeSopt(path,1,100,trainIdx);

    % 用训练出来的参数对测试集验证
    testRI = TestSetValid(path,rad,weights,initDirection,refreshDirWei,scoreWei,centerWei,testIdx);
    
    % 显示结果
    fprintf('第%d次训练最佳RI=%.4f,测试RI=%.4f 训练集:1:%d 测试集:%d:%d\n', ...
                    fold,trainRI,testRI,trainEnd,trainEnd+1,dataLength);

    mse_values(fold) = testRI;
end

plot(mse_values)
title('每次测试集的准确率')



