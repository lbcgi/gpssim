function g = date2gps(t, sysConfig)
    doy = [0,31,59,90,120,151,181,212,243,273,304,334];
    ye = t.y - 1980;
    lpdays = fix(ye/4) + 1;
    if ((mod(ye,4))==0 && t.m<=2)
		lpdays = lpdays - 1;
    end
    
    % Compute the number of days elapsed since Jan 5/Jan 6, 1980.
	de = ye*365 + doy(t.m) + t.d + lpdays - 6;
    
    g.week = fix(de / 7);
    g.sec  = mod(de,7)*sysConfig.SECONDS_IN_DAY + t.hh*sysConfig.SECONDS_IN_HOUR... 
		+ t.mm*sysConfig.SECONDS_IN_MINUTE + t.sec;