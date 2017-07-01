clc;    %清空命令行窗口
clear;  %清空工作区

data = dlmread('data.dat');         %从文本中读取数据，单位：deg/s，速率：100Hz
data = data(1:720000, 3:5)*3600;    %截取两个小时的数据，把 deg/s 转为 deg/h
[A, B] = allan(data, 100, 100);     %求Allan标准差，用100个点来描述

loglog(A, B, 'o');                  %画双对数坐标图
xlabel('time:sec');                 %添加x轴标签
ylabel('Sigma:deg/h');              %添加y轴标签
legend('X axis','Y axis','Z axis'); %添加标注
grid on;                            %添加网格线
hold on;                            %使图像不被覆盖

C(1, :) = nihe(sqrt(A'), B(:, 1)', 2)';   %拟合
C(2, :) = nihe(sqrt(A'), B(:, 2)', 2)';
C(3, :) = nihe(sqrt(A'), B(:, 3)', 2)';

Q = abs(C(:, 1)) / sqrt(3);         %量化噪声，单位：arcsec
N = abs(C(:, 2)) / 60;	            %角度随机游走，单位：deg/h^0.5
Bs = abs(C(:, 3)) / 0.6643;	        %零偏不稳定性，单位：deg/h
K = abs(C(:, 4)) * sqrt(3) * 60;	%角速率游走，单位：deg/h/h^0.5
R = abs(C(:, 5)) * sqrt(2) * 3600;	%速率斜坡，单位：deg/h/h

fprintf('量化噪声      X轴：%f Y轴：%f Z轴：%f  单位：arcsec\n', Q(1), Q(2), Q(3));
fprintf('角度随机游走  X轴：%f Y轴：%f Z轴：%f  单位：deg/h^0.5\n', N(1), N(2), N(3));
fprintf('零偏不稳定性  X轴：%f Y轴：%f Z轴：%f  单位：deg/h\n', Bs(1), Bs(2), Bs(3));
fprintf('角速率游走    X轴：%f Y轴：%f Z轴：%f  单位：deg/h/h^0.5\n', K(1), K(2), K(3));
fprintf('速率斜坡      X轴：%f Y轴：%f Z轴：%f  单位：deg/h/h\n', R(1), R(2), R(3));

D(:, 1) = C(1, 1)*sqrt(A).^(-2) + C(1, 2)*sqrt(A).^(-1) + C(1, 3)*sqrt(A).^(0) + C(1, 4)*sqrt(A).^(1) + C(1, 5)*sqrt(A).^(2);    %生成拟合函数
D(:, 2) = C(2, 1)*sqrt(A).^(-2) + C(2, 2)*sqrt(A).^(-1) + C(2, 3)*sqrt(A).^(0) + C(2, 4)*sqrt(A).^(1) + C(2, 5)*sqrt(A).^(2);
D(:, 3) = C(3, 1)*sqrt(A).^(-2) + C(3, 2)*sqrt(A).^(-1) + C(3, 3)*sqrt(A).^(0) + C(3, 4)*sqrt(A).^(1) + C(3, 5)*sqrt(A).^(2);

loglog(A, D);   %画双对数坐标图
