function reslut = NormalizeDataFromFile(filename,normalizemethodname)
    % 根据文件路径读取数据排序并进行归一化

    data = readmatrix(filename);
    sortData = sortrows(data,3);
    reslut = NormalizeData(sortData,normalizemethodname);
end
