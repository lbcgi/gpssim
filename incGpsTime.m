function g1 = incGpsTime(g0, dt, sysConfig)

    g1.week = g0.week;
    g1.sec = g0.sec + dt;
    
    g1.sec = round(g1.sec*1000.0)/1000.0; % Avoid rounding error
    
    while (g1.sec >= sysConfig.SECONDS_IN_WEEK)
	
		g1.sec =  g1.sec - sysConfig.SECONDS_IN_WEEK;
		g1.week = g1.week + 1;
    end
    
    while (g1.sec<0.0)
		g1.sec = g1.sec + sysConfig.SECONDS_IN_WEEK;
		g1.week = g1.week - 1;
    end