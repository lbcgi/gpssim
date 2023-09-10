function rho = computeRange(eph, ionoutc, g, xyz, sysConfig)  
% rho: range_t structure (output)  
% eph: ephem_t structure (input)  
% ionoutc: ionoutc_t structure (input)  
% g: gpstime_t (input)  
% xyz: double array (input)  
  
    pos = zeros(1, 3);  
    vel = zeros(1, 3);  
    clk = zeros(1, 2);  
   
    % SV position at time of the pseudorange observation.  
    [pos, vel, clk] = satpos(eph, g, sysConfig);  

    % Receiver to satellite vector and light-time.  
    los = pos - xyz;
    tau = norm(los)/sysConfig.SPEED_OF_LIGHT;  

    % Extrapolate the satellite position backwards to the transmission time.  
    pos(1) = pos(1) - vel(1)*tau;  
    pos(2) = pos(2) - vel(2)*tau;  
    pos(3) = pos(3) - vel(3)*tau;  

    % Earth rotation correction. The change in velocity can be neglected.  
    xrot = pos(1) + pos(2)*sysConfig.OMEGA_EARTH*tau;  
    yrot = pos(2) - pos(1)*sysConfig.OMEGA_EARTH*tau;  
    pos(1) = xrot;  
    pos(2) = yrot;  

    % New observer to satellite vector and satellite range.  
    los = pos - xyz;
    range = norm(los);  
    rho.d = range;  

    % Pseudorange.  
    rho.range = range - sysConfig.SPEED_OF_LIGHT*clk(1);  

    % Relative velocity of SV and receiver.  
    rate = (vel.'*los)/range;  

    % Pseudorange rate.  
    rho.rate = rate; % - SPEED_OF_LIGHT*clk(2);  

    % Time of application.  
    rho.g = g;  

    % Azimuth and elevation angles
    llh = xyz2llh(xyz, sysConfig);
    tmat = ltcmat(llh);
    neu = ecef2neu(los, tmat);
    rho.azel = neu2azel(neu);
%     rho.iono_delay = ionosphericDelay(ionoutc, g, llh, rho.azel);
    rho.iono_delay = 0.0;
    rho.range = rho.range + rho.iono_delay;

