function ret = checkSatVisibility(eph, g, xyz, elvMask, azel, sysConfig)
    % ���룺
    % eph - ����������
    % g - ���ջ�ʱ��
    % xyz - �������꣨ECEF��
    % elvMask - �ɼ�����ֵ���ԽǶ�Ϊ��λ��
    % azel - �������λ�Ǻ͸����ǣ��Զ�Ϊ��λ��
    % �����
    % 0 - ���ɼ�
    % 1 - �ɼ�
    % -1 - ��Ч
    
    if (eph.vflg ~= 1)
		ret = -1; % Invalid
        return;
    end
    
    % ת��Ϊ��������ϵ
    llh = xyz2llh(xyz, sysConfig);
    tmat = ltcmat(llh);

    % ��������λ�ú��ٶ�
    [pos, ~, ~] = satpos(eph, g, sysConfig);
    los = pos - xyz;
    neu = ecef2neu(los, tmat);
    azel = neu2azel(neu);

    % ���ɼ���
    if azel(2) * sysConfig.R2D > elvMask
        ret = 1; % �ɼ�
        return;
    end
        ret = 0; % ���ɼ�
    
end