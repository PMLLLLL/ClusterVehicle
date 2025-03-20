% 调试模板，输出日志信息

fid = fopen('debug_log.txt', 'w'); % 打开或创建文件用于写入
fprintf(fid, 'x的值为: 2\n'); % 写入日志文件
fprintf(fid, 'x的值为: 1\n'); % 写入日志文件
fclose(fid); % 关闭文件