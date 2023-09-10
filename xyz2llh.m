function llh = xyz2llh(xyz, sysConfig)
    % 常量
    a = sysConfig.WGS84_RADIUS;
    e = sysConfig.WGS84_ECCENTRICITY;
    
    % 设置精度
    eps = 1e-3;
    e2 = e^2;
    
    % 检查输入的ECEF向量是否有效
    if norm(xyz) < eps
        % 无效的ECEF向量
        llh = [0 0 -a];
        return;
    end
    
    % 提取ECEF向量的分量
    x = xyz(1);
    y = xyz(2);
    z = xyz(3);
    
    % 计算平方和
    rho2 = x^2 + y^2;
    
    % 计算高度变化
    dz = e2 * z;
    
    % 循环计算高度
    while true
        % 计算高度变化
        zdz = z + dz;
        nh = sqrt(rho2 + zdz^2);
        slat = zdz / nh;
        n = a / sqrt(1 - e2 * slat^2);
        dz_new = n * e2 * slat;
        
        % 检查高度变化是否小于精度
        if abs(dz - dz_new) < eps
            break;
        end
        
        % 更新高度变化
        dz = dz_new;
    end
    
    % 计算经纬度
    llh(1) = atan2(zdz, sqrt(rho2));
    llh(2) = atan2(y, x);
    llh(3) = nh - n;
