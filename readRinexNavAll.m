function [ieph,  eph, ionoutc] = readRinexNavAll(fname, ionoutc, sysConfig)
    
    flags = 0;
    
    fp = fopen(fname, 'rt');
    if(fp == -1)
        ieph    = -1;
        eph     = [];
        ionoutc = [];
        return;
    end
    
    % 定义常量  
    EPHEM_ARRAY_SIZE = sysConfig.EPHEM_ARRAY_SIZE; % 根据需要更改  
    MAX_SAT = sysConfig.MAX_SAT; % 根据需要更改  
  
    % 预分配内存并随机初始化eph数组  
%     eph = repmat(struct(''), EPHEM_ARRAY_SIZE, MAX_SAT);  
% 
%     % 随机初始化字段  
%     eph(:).vflg = randi([0 1], EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).t    = randi([0 1000], EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).toc = eph.t;
%     eph(:).toe = eph.t;
%     eph(:).iodc = randi([0 100], EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).iode = randi([0 100], EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).deltan = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).cuc = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).cus = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).cic = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).cis = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).crc = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).crs = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).ecc = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).sqrta = sqrt(rand(EPHEM_ARRAY_SIZE, MAX_SAT));  
%     eph(:).m0 = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).omg0 = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).inc0 = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).aop = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).omgdot = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).idot = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).af0 = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).af1 = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).af2 = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).tgd = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).svhlth = randi([0 1], EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).codeL2 = randi([0 1], EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).n = rand(EPHEM_ARRAY_SIZE, MAX_SAT);  
%     eph(:).sq1e2 = sqrt(1 - eph.ecc.^2);  
%     eph(:).A = eph.sq1e2 ./ (1 - eph.ecc.*cosd(eph.m0)); % 根据Kepler's Third Law计算半长轴A  
%     eph(:).omgkdot = eph.omgdot - eph.omg0./ eph.A; % 根据定义计算OmegaDot-OmegaEdot

    % Clear valid flag
	for ieph = 1:sysConfig.EPHEM_ARRAY_SIZE
		for sv = 1:sysConfig.MAX_SAT
			eph(ieph , sv).vflg = 0;
        end
    end
    
    while (1)
      
        str = fgets(fp, sysConfig.MAX_CHAR);
        if(str == -1)
            break;
        end
        
        if(strncmp(str(60 + (1:13)), 'END OF HEADER', 13))
            break;
        elseif(strncmp(str(60 + (1:9)), 'ION ALPHA', 9))
            tmp = str(2 + (1:12));
            tmp = replaceExpDesignator(tmp, 12); %// tmp[15]='E';
            ionoutc.alpha0 = str2double(tmp);
            
            tmp = str(14 + (1:12));
            tmp = replaceExpDesignator(tmp, 12); %// tmp[15]='E';
            ionoutc.alpha1 = str2double(tmp);
            
            tmp = str(26 + (1:12));
            tmp = replaceExpDesignator(tmp, 12); %// tmp[15]='E';
            ionoutc.alpha2 = str2double(tmp);
            
            tmp = str(38 + (1:12));
            tmp = replaceExpDesignator(tmp, 12); %// tmp[15]='E';
            ionoutc.alpha3 = str2double(tmp);
            flags = bitor(flags, 1);

        elseif(strncmp(str(60 + (1:8)), 'ION BETA', 8))
            
            tmp = str(2 + (1:12));
            tmp = replaceExpDesignator(tmp, 12); %// tmp[15]='E';
            ionoutc.beta0 = str2double(tmp);
            
            tmp = str(14 + (1:12));
            tmp = replaceExpDesignator(tmp, 12); %// tmp[15]='E';
            ionoutc.beta1 = str2double(tmp);
            
            tmp = str(26 + (1:12));
            tmp = replaceExpDesignator(tmp, 12); %// tmp[15]='E';
            ionoutc.beta2 = str2double(tmp);
            
            tmp = str(38 + (1:12));
            tmp = replaceExpDesignator(tmp, 12); %// tmp[15]='E';
            ionoutc.beta3 = str2double(tmp);
            flags = bitor(flags, 2);
                 
        elseif(strncmp(str(60 + (1:9)), 'DELTA-UTC', 9))
            
            tmp = str(3 + (1:19));
            tmp = replaceExpDesignator(tmp, 19); %// tmp[15]='E';
            ionoutc.A0 = str2double(tmp);
            
            tmp = str(22 + (1:19));
            tmp = replaceExpDesignator(tmp, 19); %// tmp[15]='E';
            ionoutc.A1 = str2double(tmp);
            
            tmp = str(41 + (1:9));
            ionoutc.tot = str2double(tmp);
            
            tmp = str(50 + (1:9));
            ionoutc.wnt = str2double(tmp);
            
            if(rem(ionoutc.tot, 4096) == 0)
                flags = bitor(flags, 4);
            end
            
        elseif(strncmp(str(60 + (1:12)), 'LEAP SECONDS', 12))
            tmp = str(1:6);
            ionoutc.dtls = str2double(tmp);
            
            flags = bitor(flags, 8);
            
        end
    end
    
    ionoutc.vflg = sysConfig.FALSE;
	if (flags == hex2dec('F')) % Read all Iono/UTC lines
		ionoutc.vflg = sysConfig.TRUE;
    end
    
    % Read ephemeris blocks
	g0.week = -1;
    
	ieph = 0;
    while (1)
        str = fgets(fp, sysConfig.MAX_CHAR);
        if(str == -1)
            break;
        end
        
        % PRN
		tmp = str(1:2);
		sv = str2double(tmp);
        
        % EPOCH
		tmp = str(3 + (1:2));
		t.y = str2double(tmp) + 2000;
        
        tmp = str(6 + (1:2));
        t.m = str2double(tmp);

        tmp = str(9 + (1:2));
        t.d = str2double(tmp);
        
        tmp = str(12 + (1:2));
        t.hh = str2double(tmp);
    
        tmp = str(15 + (1:2));
        t.mm = str2double(tmp);
        
        tmp = str(18 + (1:4));
        t.sec = str2double(tmp);
        
        g = date2gps(t, sysConfig);
        if (g0.week==-1)
			g0 = g;
        end
        
        dt = subGpsTime(g, g0, sysConfig);
        if (dt > sysConfig.SECONDS_IN_HOUR)
		
			g0 = g;
			ieph = ieph + 1; % a new set of ephemerides

			if (ieph >= sysConfig.EPHEM_ARRAY_SIZE)
				break;
            end
        end
        % Date and time
        eph(ieph + 1,sv).t = t;
        % SV CLK
        eph(ieph + 1,sv).toc = g;
       
        tmp = str(23:23+19-1);
        tmp = replaceExpDesignator(tmp, 19); %// tmp[15]='E';
        eph(ieph + 1, sv).af0 = str2double(tmp);

        tmp = str(42:42+19-1);
        tmp = replaceExpDesignator(tmp, 19); 
        eph(ieph + 1, sv).af1 = str2double(tmp);
        
        tmp = str(60 + (1:19));
        tmp = replaceExpDesignator(tmp, 19); 
        eph(ieph + 1, sv).af2 = str2double(tmp);
        
        % BROADCAST ORBIT - 1
        str = fgets(fp, sysConfig.MAX_CHAR);
		if (str == --1)
			break;
        end
        
        tmp = str(3 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).iode = str2double(tmp);
        
        tmp = str(22 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).crs = str2double(tmp);
        
        tmp = str(41 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).deltan = str2double(tmp);
        
        tmp = str(60 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).m0 = str2double(tmp);
        
        % BROADCAST ORBIT - 2
        str = fgets(fp, sysConfig.MAX_CHAR);
		if (str== -1)
			break;
        end
        
        tmp = str(3 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).cuc = str2double(tmp);
        
        tmp = str(22 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).ecc = str2double(tmp);
        
        tmp = str(41 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).cus = str2double(tmp);
        
        tmp = str(60 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).sqrta = str2double(tmp);
        
        % BROADCAST ORBIT - 3
        str = fgets(fp, sysConfig.MAX_CHAR);
		if (str== -1)
			break;
        end
        
        tmp = str(3 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).toe.sec = str2double(tmp);
        
        tmp = str(22 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).cic = str2double(tmp);
        
        tmp = str(41 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).omg0 = str2double(tmp);
        
        tmp = str(60 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).cis = str2double(tmp);
        
        % BROADCAST ORBIT - 4
        str = fgets(fp, sysConfig.MAX_CHAR);
		if (str== -1)
			break;
        end
        
        tmp = str(3 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).inc0 = str2double(tmp);
        
        tmp = str(22 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).crc = str2double(tmp);
        
        tmp = str(41 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).aop = str2double(tmp);
        
        tmp = str(60 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).omgdot = str2double(tmp);
        
        % BROADCAST ORBIT - 5
        str = fgets(fp, sysConfig.MAX_CHAR);
		if (str== -1)
			break;
        end
        
        tmp = str(3 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).idot = str2double(tmp);
        
        tmp = str(22 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).codeL2 = str2double(tmp);
        
        tmp = str(41 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).toe.week = str2double(tmp);
        
         % BROADCAST ORBIT - 6
        str = fgets(fp, sysConfig.MAX_CHAR);
		if (str == -1)
			break;
        end
        
        tmp = str(22 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).svhlth = str2double(tmp);
        if ((eph(ieph + 1, sv).svhlth>0) && (eph(ieph + 1, sv).svhlth<32))
			eph(ieph + 1, sv).svhlth =  eph(ieph + 1, sv).svhlth  + 32; % Set MSB to 1
        end
        
        tmp = str(41 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).tgd = str2double(tmp);
        
        tmp = str(60 + (1:19));
        tmp = replaceExpDesignator(tmp, 19);
        eph(ieph + 1, sv).iodc = str2double(tmp);
        
        % BROADCAST ORBIT - 7
        str = fgets(fp, sysConfig.MAX_CHAR);
		if (str == -1)
            break;
        end
        
        % Set valid flag
        eph(ieph + 1, sv).vflg = 1;
        eph(ieph + 1, sv).A = eph(ieph + 1, sv).sqrta * eph(ieph + 1, sv).sqrta;
		eph(ieph + 1, sv).n = sqrt(sysConfig.GM_EARTH/(eph(ieph + 1, sv).A*eph(ieph + 1, sv).A*eph(ieph + 1, sv).A)) + eph(ieph + 1, sv).deltan;
		eph(ieph + 1, sv).sq1e2 = sqrt(1.0 - eph(ieph + 1, sv).ecc*eph(ieph + 1, sv).ecc);
		eph(ieph + 1, sv).omgkdot = eph(ieph + 1, sv).omgdot - sysConfig.OMEGA_EARTH;
      
    end
    
    fclose(fp);
        
%     if (g0.week >= 0 )
%         ieph  = ieph + 1; % Number of sets of ephemerides
%     end
        

