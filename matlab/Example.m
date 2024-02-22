clc;
clear;

% 定义xz平面的范围和分辨率start_x = -4;   % x轴位置
start_x = -3;       % x轴起始位置 单位厘米
start_z = 0.1;      % z轴起始位置 单位厘米
end_x = 3;          % 
end_z = 5;


xn = 20;
zn = end_z*10;
xRange = linspace( start_x, end_x, xn ); 
zRange = linspace( start_z, end_z, zn );
[X, Z] = meshgrid(xRange, zRange);

% 初始化磁场强度矩阵
Bz = zeros(size(X));

% 计算每个点的磁场强度
for i = 1:numel(X)
    B = calculateMagneticField(X(i)/100,0, Z(i)/100+eps);
    Bz(i) = B(3) * 1e3; % 使用函数返回的Bz分量
end

surf(  Bz );
view(0,90);
colorbar;
shading interp;     % 是否应用插值以平滑颜色过渡

h = colorbar;
h.Label.String = 'Z Magnetic Field Intensity(mT)';
h.Label.FontSize = 13;

xlim([1,xn]);
ylim([1,zn]);

xticks(linspace(1, xn, 5));  % 指定刻度位置
xticklabels({'-50', '-25', '0', '25', '50'});  % 自定义刻度标签

xlabel('Radial Distance (mm)','FontSize',13);
ylabel('Axial Distance (mm)','FontSize',13)
shading interp;     % 是否应用插值以平滑颜色过渡