function chan = computeCodePhase(chan, rho1, dt, sysConfig)  
    % chan: channel_t structure (updated)  
    % rho1: Current range, after dt has expired  
    % dt: delta-t (time difference) in seconds  

    % Pseudorange rate  
    rhorate = (rho1.range - chan.rho0.range)/dt;  

    % Carrier and code frequency  
    chan.f_carr = -rhorate/sysConfig.LAMBDA_L1;  
    %chan.f_carr = 0; % Debug Œﬁ∂‡∆’¿’  
    chan.f_code = sysConfig.CODE_FREQ + chan.f_carr*sysConfig.CARR_TO_CODE;  

    % Initial code phase and data bit counters  
    ms = ((subGpsTime(chan.rho0.g,chan.g0, sysConfig)+6.0) - chan.rho0.range/sysConfig.SPEED_OF_LIGHT)*1000.0;  

    ims = floor(ms);  
    chan.code_phase = (ms-ims)*sysConfig.CA_SEQ_LEN; % in chip  

    chan.iword = fix(ims/600); % 1 word = 30 bits = 600 ms  
    ims = mod(ims, 600);  

    chan.ibit = fix(ims/20); % 1 bit = 20 code = 20 ms  
    ims = mod(ims, 20);  

    % icode is used for counting, every 20ms is a bit  
    chan.icode = ims; % 1 code = 1 ms  

    chan.codeCA = chan.ca(int32(chan.code_phase)+1)*2-1;  
    chan.dataBit = bitand(bitshift(chan.dwrd(chan.iword+1), -(29-chan.ibit)), 1)*2-1;  

    % Save current pseudorange  
    chan.rho0 = rho1;  
end
