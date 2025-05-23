function dis = EuclideanDistance(weight,point1, point2)
    % 计算两个点之间的欧式距离加权和
    % 输入：
    %   point1 - 第一个点的坐标，可以是向量或矩阵
    %   point2 - 第二个点的坐标，维度应与point1相同
    % 输出：
    %   distance - 两点之间的欧式距离
    
    % 检查输入参数
    % if nargin ~= 3
    %     error('需要三个输入参数');
    % end
    % 
    % % 确保两个点具有相同的维度
    % if numel(point1) ~= numel(point2)
    %     error('输入点的维度不匹配');
    % end
    
    % 计算距离

    dis = sqrt(sum((weight .* (point1 - point2)).^2));

    % dis = sqrt(sum(weight .* (point1 - point2).^2));

end
