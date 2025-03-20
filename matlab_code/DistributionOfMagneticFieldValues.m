clear;

% 对磁场之的数据进行多种归一化处理查看结果

path = '../2025.3.3 85个数据汇总_标签.xlsx';
DataOper = DataProcessing(path);
%MagneticValues = DataOper.normalizedData(:,4)';

% 将磁场数据按值切分
MagneticValues = DataOper.dataIn(:,4)';
MagneticValues = sort(MagneticValues); %#ok<TRSRT>

figure;
stem(MagneticValues,'.');
title("原始磁场数据");
figure;
histogram(MagneticValues)
title("原始磁场数据直方图");

% 直接归一化处理原始磁场数据
MagneticValuesNormail = Normal(MagneticValues);
figure;
stem(MagneticValuesNormail,'.');
title("原始磁场数据归一化");


%%
% 对数处理
logMagneticValues = log(MagneticValues);
logMagneticValues = Normal(logMagneticValues);

figure;
stem(logMagneticValues,'.');
title("对数处理磁场数据");
figure;
histogram(logMagneticValues)
title("对数处理磁场数据直方图");


%%
Storey1 = [1000 5000];
Storey2 = [375 1000];
Storey3 = [0 375];

Storey1Values = MagneticValues(MagneticValues>=Storey1(1) & MagneticValues<Storey1(2));
Storey2Values = MagneticValues(MagneticValues>=Storey2(1) & MagneticValues<Storey2(2));
Storey3Values = MagneticValues(MagneticValues>=Storey3(1) & MagneticValues<Storey3(2));

Storey1ValuesNormal = 2.2+Normal(Storey1Values);
Storey2ValuesNormal = 1.2+Normal(Storey2Values);
Storey3ValuesNormal = Normal(Storey3Values);

StoreyValuesNormalAll = Normal([Storey3ValuesNormal Storey2ValuesNormal Storey1ValuesNormal]);

figure;
stem(StoreyValuesNormalAll,'.');
title("分层处理磁场数据");
figure;
histogram(StoreyValuesNormalAll)
title("分层处理磁场数据直方图");

function results = Normal(data)
    results = (data-min(data))/(max(data)-min(data));
end