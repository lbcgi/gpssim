function t = ltcmat(llh)
    % 输入：llh - 经纬度（纬度，经度）
    % t - 输出矩阵

    slat = sin(llh(1));
    clat = cos(llh(1));
    slon = sin(llh(2));
    clon = cos(llh(2));

    t(1, 1) = -slat*clon;
    t(1, 2) = -slat*slon;
    t(1, 3) = clat;
    t(2, 1) = -slon;
    t(2, 2) = clon;
    t(2, 3) = 0;
    t(3, 1) = clat*clon;
    t(3, 2) = clat*slon;
    t(3, 3) = slat;