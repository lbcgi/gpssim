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
  
    for i = 0:sysConfig.CA_SEQ_LEN - 1  
        g1(i + 1) = r1(10);  
        g2(i + 1) = r2(10);  
        c1 = r1(3) * r1(10);  
        c2 = r2(2) * r2(3) * r2(6) * r2(8) * r2(9) * r2(10);  
  
        for j = 9:-1:1 
            r1(j + 1) = r1(j);  
            r2(j + 1) = r2(j);  
        end  
        r1(1) = c1;  
        r2(1) = c2;  
    end  
   
    ca = NaN(1, sysConfig.CA_SEQ_LEN);
    j = sysConfig.CA_SEQ_LEN - delay(prn);
    for i = 0:sysConfig.CA_SEQ_LEN - 1  
        jt = rem(j, sysConfig.CA_SEQ_LEN);  
        ca(i + 1) = (1 - g1(i + 1) * g2(jt+1)) / 2; 
        j = j + 1;
    end  
end