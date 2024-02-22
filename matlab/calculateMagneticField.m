function B = calculateMagneticField(x0, y0, z0)
    % 常数定义
    mu0 = 4*pi*1e-7; % 真空的磁导
    I = 3;      % 电流强度，单位为安培
    
    R_in = 0.01;        % 内径 单位米
    R_out = 0.02;      % 外径 单位米
    R_N = 20;           % 匝数
    R_step = (R_out-R_in)/R_N;
    
    N = 200;   % 分割线圈的段数，增加这个值可以提高计算精度
    
    % 初始化磁场分量
    Bx = 0;
    By = 0;
    Bz = 0;
    
    % 线圈上的微小角度变化
    dt = 2*pi/N;
    
    for R = R_in:R_step:R_out
        % 对线圈上的所有段进行积分
        for i = 1:N
            
            % 计算当前段的角度和位置
            theta = eps + (i) * dt;
            xt = eps + R * cos(theta);
            yt = eps + R * sin(theta);
            zt = eps + 0;
            
            % 从当前段到计算点的矢量距离
            rx = x0 - xt;
            ry = y0 - yt; % 线圈在XY平面上
            rz = z0 - zt; % 计算点的Z坐标

            rr = sqrt(rx^2 + ry^2 + rz^2);
            r3 = rr^3;
            
            % 常数项
            B0 = mu0*I/(4*pi);
            
            % 中间量
            x1t = - R * sin(theta);
            y1t = R * cos(theta);
            z1t = 0;
            
            Bxk = B0 * ( (z0-zt)*y1t - (y0-yt) * z1t ) / r3;
            Byk = B0 * ( (z0-zt)*x1t - (x0-xt) * z1t ) / r3;
            Bzk = B0 * ( (y0-yt)*x1t - (x0-xt) * y1t ) / r3;
            
            % 磁场分量的方向
            Bx = Bx + Bxk * dt;
            By = By + Byk * dt;
            Bz = Bz + Bzk * dt;
        end
    end
    
    % 输出磁场分量，注意By始终为0，因为线圈平面内没有垂直分量
    B = [Bx, By, Bz];
end
