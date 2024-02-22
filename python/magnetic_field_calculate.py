import matplotlib.pyplot as plt
import numpy as np

def calculate_magnetic_field(x0, y0, z0):
    mu0 = 4*np.pi*1e-7  # 真空的磁导
    I = 3           # 电流强度，单位为安培 用户自定义修改
    R_in = 0.01     # 内径 单位米 用户自定义
    R_out = 0.02    # 外径 单位米 用户自定义
    R_N = 20        # 匝数 用户自定义
    R_step = (R_out-R_in)/R_N
    N = 200  # 分割线圈的段数 这个数字越高仿真精准度越高
    
    dt = 2*np.pi/N  # 线圈上的微小角度变化
    
    # 预先计算所有角度
    theta = np.arange(dt, 2*np.pi + dt, dt)
    R = np.arange(R_in, R_out + R_step, R_step)
    
    Bx = 0
    By = 0
    Bz = 0
    
    for r in R:
        xt = r * np.cos(theta)
        yt = r * np.sin(theta)
        zt = np.zeros_like(xt)
        
        rx = x0 - xt
        ry = y0 - yt
        rz = z0 - zt
        
        rr = np.sqrt(rx**2 + ry**2 + rz**2)
        r3 = rr**3
        
        # 常数项
        B0 = mu0 * I / (4 * np.pi)
        
        x1t = -np.sin(theta) * r
        y1t = np.cos(theta) * r
        z1t = np.zeros_like(x1t)
        
        Bxk = B0 * ((z0 - zt) * y1t - (y0 - yt) * z1t) / r3
        Byk = B0 * ((z0 - zt) * x1t - (x0 - xt) * z1t) / r3
        Bzk = B0 * ((y0 - yt) * x1t - (x0 - xt) * y1t) / r3
        
        Bx += np.sum(Bxk) * dt
        By += np.sum(Byk) * dt
        Bz += np.sum(Bzk) * dt
        
    return [Bx, By, Bz]

# 调用这个函数就能得到长枪
# calculate_magnetic_field(0.01, 0, 0)


# 定义xz平面的范围和分辨率
start_x = -3    # x轴起始位置 单位厘米
start_z = 0.2   # z轴起始位置 单位厘米
end_x = 3
end_z = 2
xn = 50         # 看把平面切成几份了
zn = 50

xRange = np.linspace(start_x, end_x, xn)
zRange = np.linspace(start_z, end_z, zn)
X, Z = np.meshgrid(xRange, zRange)

# 初始化磁场强度矩阵
Bz = np.zeros(X.shape)

# 计算每个点的磁场强度
for i in range(X.size):
    # 注意单位转换，输入的单位是标准单位米
    B = calculate_magnetic_field(X.flat[i]/100, 0, Z.flat[i]/100)
    Bz.flat[i] = B[2] * 1e3  # 这里展示z方向场强，单位转换为毫特斯拉(mT)

# 绘制
fig = plt.figure()
plt.contourf(X,Z,Bz)
plt.show()
