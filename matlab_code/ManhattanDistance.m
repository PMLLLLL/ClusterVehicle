function dist = ManhattanDistance(weight,point1, point2)
    % 计算两个向量之间的曼哈顿距离加权
    % 输入：x, y 必须是相同长度的向量
    % 输出：曼哈顿距离
    % 检查输入参数
    % if nargin ~= 3
    %     error('需要三个输入参数');
    % end
    % 
    % if length(point1) ~= length(point2)
    %     error('输入向量长度必须相同');
    % end
    
    dist = sum(weight .* abs(point1 - point2));
end