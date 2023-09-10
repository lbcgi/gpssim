function xyz = llh2xyz(llh, sysConfig)
    
    a = sysConfig.WGS84_RADIUS;
    e = sysConfig.WGS84_ECCENTRICITY;
    e2 = e*e;
    
    clat = cos(llh(1));
	slat = sin(llh(1));
	clon = cos(llh(2));
	slon = sin(llh(2));
	d = e*slat;

	n = a/sqrt(1.0-d*d);
	nph = n + llh(3);

	tmp = nph*clat;
	xyz(1) = tmp*clon;
	xyz(2) = tmp*slon;
	xyz(3) = ((1.0-e2)*n + llh(3))*slat;