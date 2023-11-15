function ret = checkSatVisibility(eph, g, xyz, elvMask, azel, sysConfig)
    % 输入：
    % eph - 地球轨道参数
    % g - 接收机时间
    % xyz - 卫星坐标（ECEF）
    % elvMask - 可见度阈值（以角度为单位）
    % azel - 输出：方位角和俯仰角（以度为单位）
    % 输出：
    % 0 - 不可见
    % 1 - 可见
    % -1 - 无效
    
    if (eph.vflg ~= 1)
		ret = -1; % Invalid
        return;
    end
    
    % 转换为本地坐标系
    llh = xyz2llh(xyz, sysConfig);
    tmat = ltcmat(llh);

    % 计算卫星位置和速度
    [pos, ~, ~] = satpos(eph, g, sysConfig);
    los = pos - xyz;
    neu = ecef2neu(los, tmat);
    azel = neu2azel(neu);

    % 检查可见度
    if azel(2) * sysConfig.R2D > elvMask
        ret = 1; % 可见
        return;
    end
        ret = 0; % 不可见
    
end