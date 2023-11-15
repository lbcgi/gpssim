function dt = subGpsTime(g1, g0, sysConfig)
%     g1_sec = g1.sec
%     g0_sec = g0.sec
    
%     g1_week = g1.week
%     g0_week = g0.week
    
    dt = g1.sec - g0.sec;
	dt = dt + (g1.week - g0.week) * sysConfig.SECONDS_IN_WEEK;