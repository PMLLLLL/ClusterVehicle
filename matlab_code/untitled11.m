% 定义起点和向量
start = [0, 0, 0];
vector = [1, 2, 3];

% 绘制
figure;
quiver3(start(1), start(2), start(3), ...
        vector(1), vector(2), vector(3), ...
        0, 'LineWidth', 2, 'MaxHeadSize', 0.5);
hold on;
plot3(start(1), start(2), start(3), 'ro');
axis equal;
grid on;
title('3D向量');
xlabel('X');
ylabel('Y');
zlabel('Z');
view(30, 30);