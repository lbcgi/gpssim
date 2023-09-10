function azel = neu2azel(neu)

% brief Convert North-East-Up to Azimuth + Elevation
% param[in] neu Input position in North-East-Up format
% param[out] azel Output array of azimuth + elevation as double 

    azel(1) = atan2(neu(2), neu(1));   
    if azel(1) < 0.0  
        azel(1) = azel(1) + (2.0 * pi);  
    end  
    ne = sqrt(neu(1)^2 + neu(2)^2);  
    azel(2) = atan2(neu(3), ne); 

