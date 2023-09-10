function llh = xyz2llh(xyz, sysConfig)
    % ����
    a = sysConfig.WGS84_RADIUS;
    e = sysConfig.WGS84_ECCENTRICITY;
    
    % ���þ���
    eps = 1e-3;
    e2 = e^2;
    
    % ��������ECEF�����Ƿ���Ч
    if norm(xyz) < eps
        % ��Ч��ECEF����
        llh = [0 0 -a];
        return;
    end
    
    % ��ȡECEF�����ķ���
    x = xyz(1);
    y = xyz(2);
    z = xyz(3);
    
    % ����ƽ����
    rho2 = x^2 + y^2;
    
    % ����߶ȱ仯
    dz = e2 * z;
    
    % ѭ������߶�
    while true
        % ����߶ȱ仯
        zdz = z + dz;
        nh = sqrt(rho2 + zdz^2);
        slat = zdz / nh;
        n = a / sqrt(1 - e2 * slat^2);
        dz_new = n * e2 * slat;
        
        % ���߶ȱ仯�Ƿ�С�ھ���
        if abs(dz - dz_new) < eps
            break;
        end
        
        % ���¸߶ȱ仯
        dz = dz_new;
    end
    
    % ���㾭γ��
    llh(1) = atan2(zdz, sqrt(rho2));
    llh(2) = atan2(y, x);
    llh(3) = nh - n;
