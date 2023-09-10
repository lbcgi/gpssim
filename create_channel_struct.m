function channel = create_channel_struct(sysConfig)  
    channel.prn = 0; % PRN Number  
    channel.ca = zeros(1, sysConfig.CA_SEQ_LEN); % C/A Sequence  
    channel.f_carr = 0.0; % Carrier frequency  
    channel.f_code = 0.0; % Code frequency  
  
    channel.carr_phase = uint32(0); % Carrier phase  
   
    channel.code_phase = 0.0; % Code phase  
    channel.g0 = 0; % GPS time at start  
    channel.sbf = zeros(5, sysConfig.N_DWRD_SBF); % current subframe  
    channel.dwrd = zeros(1, sysConfig.N_DWRD); % Data words of sub-frame  
    channel.iword = 0; % initial word  
    channel.ibit = 0; % initial bit  
    channel.icode = 0; % initial code  
    channel.dataBit = 0; % current data bit  
    channel.codeCA = 0; % current C/A code  
    channel.azel = zeros(1, 2);  
    channel.rho0 = 0;  
end