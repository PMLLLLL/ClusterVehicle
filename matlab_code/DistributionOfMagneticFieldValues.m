clear;

% 对磁场之的数据进行多种归一化处理查看结果

path = '../2025.3.3 85个数据汇总_标签.xlsx';
DataOper = DataProcessing(path);
%MagneticValues = DataOper.normalizedData(:,4)';

% 将磁场数据按值切分
MagneticValues = DataOper.dataIn(:,4)';
MagneticValues1 = MagneticValues(MagneticValues < 1500);
MagneticValues2 = MagneticValues(MagneticValues >= 1500);

figure;
stem([MagneticValues1 MagneticValues2],'.');
title("原始磁场数据");
figure;
histogram(MagneticValues)
title("原始磁场数据直方图");

% 对数处理
logMagneticValues1 = log(MagneticValues1-50);
logMagneticValues2 = log(MagneticValues2-50);

% 计算方差
logMagneticValues1Var = var(logMagneticValues1);
logMagneticValues2Var = var(logMagneticValues2);

divideLogMagneticValues2Var = logMagneticValues2Var/logMagneticValues1Var;


figure;
stem([logMagneticValues1 logMagneticValues2],'.');
title("对数处理磁场数据");
figure;
histogram([logMagneticValues1 logMagneticValues2])
title("对数处理磁场数据直方图");


%%
% 计算方差
MagneticValues1_var = var(MagneticValues1,1);
MagneticValues2_var = var(MagneticValues2,1);
divide = MagneticValues2_var/MagneticValues1_var;

% 除以方差
normalizedMagneticValues1 = MagneticValues1/MagneticValues1_var;
normalizedMagneticValues2 = MagneticValues2/MagneticValues2_var*10;

% 查看高磁场值是否大于地磁场值
maxNormalizedMagneticValues1_var = max(normalizedMagneticValues1);
minNormalizedMagneticValues2_var = min(normalizedMagneticValues2);

% 查看方差变化
normalizedMagneticValues1_var = var(normalizedMagneticValues1);
normalizedMagneticValues2_var = var(normalizedMagneticValues2);
normalizeddivide = normalizedMagneticValues2_var/normalizedMagneticValues1_var;

figure;
stem([normalizedMagneticValues1 normalizedMagneticValues2],'.');
title("分层处理磁场数据");
figure;
histogram([normalizedMagneticValues1 normalizedMagneticValues2])
title("分层处理磁场数据直方图");