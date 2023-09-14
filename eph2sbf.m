
% brief Compute Subframe from Ephemeris
% param[in] eph Ephemeris of given SV
% param[out] sbf Array of five sub-frames, 10 long words each
 
function sbf = eph2sbf(eph, ionoutc, sysConfig)
    
    ura = 0;  
    dataId = 1;  
    sbf4_page25_svId = 63;  
    sbf5_page25_svId = 51;  
    sbf4_page18_svId = 56;  
    wn = 0; % 初始化为0  
    toe = uint32(eph.toe.sec/16.0);  
    toc = uint32(eph.toc.sec/16.0);  
    iode = uint32(eph.iode);  
    iodc = uint32(eph.iodc);  
    deltan = int32(eph.deltan/sysConfig.POW2_M43/pi);  
    cuc = int32(eph.cuc/sysConfig.POW2_M29);  
    cus = int32(eph.cus/sysConfig.POW2_M29);  
    cic = int32(eph.cic/sysConfig.POW2_M29);  
    cis = int32(eph.cis/sysConfig.POW2_M29);  
    crc = int32(eph.crc/sysConfig.POW2_M5);  
    crs = int32(eph.crs/sysConfig.POW2_M5);  
    ecc = uint32(eph.ecc/sysConfig.POW2_M33);  
    sqrta = uint32(eph.sqrta/sysConfig.POW2_M19);  
    m0 = int32(eph.m0/sysConfig.POW2_M31/pi);  
    omg0 = int32(eph.omg0/sysConfig.POW2_M31/pi);  
    inc0 = int32(eph.inc0/sysConfig.POW2_M31/pi);  
    aop = int32(eph.aop/sysConfig.POW2_M31/pi);  
    omgdot = int32(eph.omgdot/sysConfig.POW2_M43/pi);  
    idot = int32(eph.idot/sysConfig.POW2_M43/pi);  
    af0 = int32(eph.af0/sysConfig.POW2_M31);  
    af1 = int32(eph.af1/sysConfig.POW2_M43);  
    af2 = int32(eph.af2/sysConfig.POW2_M55);  
    tgd = int32(eph.tgd/sysConfig.POW2_M31);  
    svhlth = uint32(eph.svhlth);  
    codeL2 = uint32(eph.codeL2);  

    wna = uint32(mod(eph.toe.week,256));  
    toa = uint32(eph.toe.sec/4096.0);  

    alpha0 = int32(round(ionoutc.alpha0/sysConfig.POW2_M30));  
    alpha1 = int32(round(ionoutc.alpha1/sysConfig.POW2_M27));  
    alpha2 = int32(round(ionoutc.alpha2/sysConfig.POW2_M24));  
    alpha3 = int32(round(ionoutc.alpha3/sysConfig.POW2_M24));  
    beta0 = int32(round(ionoutc.beta0/2048.0));  
    beta1 = int32(round(ionoutc.beta1/16384.0));  
    beta2 = int32(round(ionoutc.beta2/65536.0));  
    beta3 = int32(round(ionoutc.beta3/65536.0));  
    A0 = int32(round(ionoutc.A0/sysConfig.POW2_M30));  
    A1 = int32(round(ionoutc.A1/sysConfig.POW2_M50));  
    dtls = int32(ionoutc.dtls);  
    tot = uint32(ionoutc.tot/4096);  
    wnt = uint32(mod(ionoutc.wnt,256)); 
  
    % 以下是对于你的待做事项的部分假设  
    % 假设WNlsf和DN是你要用的变量  
    wnlsf = fix(1929/256);  
    dn = 7;  
    dtlsf = 18;

    % Subframe 1  
    sbf(1,1) = bitshift(hex2dec('8B0000'),6);  
    sbf(1,2) = bitshift(hex2dec('1'),8);  
    sbf(1,3) = bitor(bitor(bitor(bitshift(bitand(wn,hex2dec('3FF')),20), ...
        bitshift(bitand(codeL2,hex2dec('3')),18)), bitshift(bitand(ura,hex2dec('F')),14)), ...
                                                bitshift(bitand(svhlth,hex2dec('3F')),8));
    sbf(1,4:6) = 0;  
    sbf(1,7) = bitshift(bitand(tgd,hex2dec('FF')), 6);  
    sbf(1,8) = bitshift(bitor(bitshift(bitand(iodc,hex2dec('FF')),22), ...
                                                                    bitshift(bitand(toc,hex2dec('FFFF')),6)), 0);  
    sbf(1,9) = bitshift(bitor(bitshift(bitand(af2,hex2dec('FF')),22), ...
                                                                    bitshift(bitand(af1,hex2dec('FFFF')),6)), 0);  
    sbf(1,10) = bitshift(bitand(af0,hex2dec('3FFFFF')), 8);  

    % Subframe 2  
    sbf(2,1) = bitshift(hex2dec('8B0000'),6);  
    sbf(2,2) = bitshift(hex2dec('2'),8);  
    sbf(2,3) = bitor(bitshift(bitand(iode,hex2dec('FF')),22), ...
                        uint32(bitshift(bitand(crs,hex2dec('FFFF')),6)));  
    sbf(2,4) = bitor(bitshift(bitand(deltan,hex2dec('FFFF')),14), ...
                        bitshift(bitand(bitshift(m0,-24),hex2dec('FF')),6),'int32');  
    sbf(2,5) = bitshift(bitand(m0,hex2dec('FFFFFF')),6);  
    sbf(2,6) = bitor(uint32(bitshift(bitand(cuc,hex2dec('FFFF')),14)), ...
                        bitshift(bitand(bitshift(ecc,-24),hex2dec('FF')),6));  
    sbf(2,7) = bitshift(bitand(ecc,hex2dec('FFFFFF')),6);  
    sbf(2,8) = bitor(uint32(bitshift(bitand(cus,hex2dec('FFFF')),14)), ...
                        bitshift(bitand(bitshift(sqrta,-24),hex2dec('FF')),6));  
    sbf(2,9) = bitshift(bitand(sqrta,hex2dec('FFFFFF')),6);  
    sbf(2,10) = bitshift(bitand(toe,hex2dec('FFFF')),14);

    % Subframe 3  
    sbf(3,1) = bitshift(hex2dec('8B0000'),6);  
    sbf(3,2) = bitshift(hex2dec('3'),8);  
    sbf(3,3) = bitor(bitshift(bitand(cic,hex2dec('FFFF')),14), ...
                        bitshift(bitand(bitshift(omg0,-24),hex2dec('FF')),6));
    sbf(3,4) = bitshift(bitand(omg0,hex2dec('FFFFFF')), 6);  
    sbf(3,5) = bitor(bitshift(bitand(cis,hex2dec('FFFF')),14), ...
                        bitshift(bitand(bitshift(inc0,-24),hex2dec('FF')),6));  
    sbf(3,6) = bitshift(bitand(inc0,hex2dec('FFFFFF')),6);  
    sbf(3,7) = bitor(bitshift(bitand(crc,hex2dec('FFFF')),14), ...
                        bitshift(bitand(bitshift(aop,-24),hex2dec('FF')),6));  
    sbf(3,8) = bitshift(bitand(aop,hex2dec('FFFFFF')),6);  
    sbf(3,9) = bitshift(bitand(omgdot,hex2dec('FFFFFF')),6);  
    sbf(3,10) = bitor(bitshift(bitand(iode,hex2dec('FF')),22), ...
                        uint32(bitshift(bitand(idot,hex2dec('3FFF')),8)));

    if (ionoutc.vflg==sysConfig.TRUE)
        sbf(4,1) = bitshift(hex2dec('8B0000'),6);  
        sbf(4,2) = bitshift(hex2dec('4'),8); 
        sbf(4,3) = bitor(bitor(bitshift(dataId,28), bitshift(sbf4_page18_svId,22)), ...
                                bitor(bitshift(bitand(alpha0,hex2dec('FF')),14), bitshift(bitand(alpha1,hex2dec('FF')),6)));
        sbf(4,4) = bitor(bitor(bitshift(bitand(alpha2,hex2dec('FF')),22), ...
                                            bitshift(bitand(alpha3,hex2dec('FF')),14)), bitshift(bitand(beta0,hex2dec('FF')),6));  
        sbf(4,5) = bitor(bitor(bitshift(bitand(beta1,hex2dec('FF')),22), ...
                                        bitshift(bitand(beta2,hex2dec('FF')),14)), bitshift(bitand(beta3,hex2dec('FF')),6));  
        sbf(4,6) = bitshift(bitand(A1,hex2dec('FFFFFF')),6);  
        sbf(4,7) = bitshift(bitand(bitshift(A0,-8),hex2dec('FFFFFF')),6);  
        sbf(4,8) = bitor(bitor(uint32(bitshift(bitand(A0,hex2dec('FF')),22)), ...
                                                    bitshift(bitand(tot,hex2dec('FF')),14)), bitshift(bitand(wnt,hex2dec('FF')),6));  
        sbf(4,9) = bitor(bitor(bitshift(bitand(dtls,hex2dec('FF')),22), ...
                                            bitshift(bitand(wnlsf,hex2dec('FF')),14)), bitshift(bitand(dn,hex2dec('FF')),6));  
        sbf(4,10) = bitshift(bitand(dtlsf,hex2dec('FF')),22);
    else
        sbf(4,1) = bitshift(hex2dec('8B0000'),6);  
        sbf(4,2) = bitshift(hex2dec('4'),8);  
        sbf(4,3) = bitor(bitshift(dataId,28), bitshift(sbf4_page25_svId,22));
        sbf(4,4:10) = 0;
    end

    sbf(5,1) = bitshift(hex2dec('8B0000'),6);
    sbf(5,2) = bitshift(hex2dec('5'),8);
    sbf(5,3) = bitor(bitor(bitshift(dataId,28), bitshift(sbf5_page25_svId,22)),...
                            bitor(bitshift(bitand(toa,hex2dec('FF')),14), bitshift(bitand(wna,hex2dec('FF')),6)));
    sbf(5,4:10) = 0;
