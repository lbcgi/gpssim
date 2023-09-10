function ca = codegen(prn, sysConfig)  
   
    delay = [5, 6, 7, 8, 17, 18, 139, 140, 141, 251, 252, 254, 255, 256, 257, 258, 469, 470, 471, 472, 473, 474, 509, 512, 513, 514, 515, 516, 859, 860, 861, 862];  
    g1 = zeros(1, sysConfig.CA_SEQ_LEN);  
    g2 = zeros(1, sysConfig.CA_SEQ_LEN);  
    r1 = -ones(1, sysConfig.N_DWRD_SBF);  
    r2 = -ones(1, sysConfig.N_DWRD_SBF);  
    
    if (prn < 1 || prn > 32)  
        ca = [];
        return;  
    end
    
    for i = 1:sysConfig.N_DWRD_SBF  
        r1(i) = -1;  
        r2(i) = -1;  
    end  
  
    for i = 1:sysConfig.CA_SEQ_LEN  
        g1(i) = r1(9);  
        g2(i) = r2(9);  
        c1 = r1(2) * r1(9);  
        c2 = r2(1) * r2(2) * r2(5) * r2(7) * r2(8) * r2(9);  
  
        for j = 10:-1:2  
            r1(j) = r1(j-1);  
            r2(j) = r2(j-1);  
        end  
        r1(1) = c1;  
        r2(1) = c2;  
    end  
   
    ca = NaN(1, sysConfig.CA_SEQ_LEN);
    for i = 1:sysConfig.CA_SEQ_LEN  
        j = mod(i + delay(prn) - 1, sysConfig.CA_SEQ_LEN);  
        ca(i) = (1 - g1(i) * g2(j+1)) / 2;  
    end  
end