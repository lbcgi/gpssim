function dt = subGpsTime(g1, g0, sysConfig)
    dt = g1.sec - g0.sec;
	dt = dt + (g1.week - g0.week) * sysConfig.SECONDS_IN_WEEK;