function chan = computeCodePhase(chan, rho1, dt, sysConfig)  
    % chan: channel_t structure (updated)  
    % rho1: Current range, after dt has expired  
    % dt: delta-t (time difference) in seconds  
    format long
    % Pseudorange rate  
    rhorate = (rho1.range - chan.rho0.range)/dt;  

    % Carrier and code frequency  
    chan.f_carr = -rhorate/sysConfig.LAMBDA_L1;  
%     chan.f_carr = 0; % Debug ÎÞ¶àÆÕÀÕ  
    chan.f_code = sysConfig.CODE_FREQ + chan.f_carr*sysConfig.CARR_TO_CODE;  
%     disp('chan.g0:')
%     disp(chan.g0)

    % Initial code phase and data bit counters  
    ms = ((subGpsTime(chan.rho0.g,chan.g0, sysConfig)+6.0) - chan.rho0.range/sysConfig.SPEED_OF_LIGHT)*1000.0;  

    ims = fix(ms);  
    chan.code_phase = (ms-ims)*sysConfig.CA_SEQ_LEN; % in chip  

    chan.iword = fix(ims/600); % 1 word = 30 bits = 600 ms  
%   fprintf('Debug:chan iword is:%4.3f\n', chan.iword);
%   ims = mod(ims, 600);  
    ims = ims - chan.iword*600;

    chan.ibit = fix(ims/20); % 1 bit = 20 code = 20 ms  
    ims = ims - chan.ibit*20;
    
    % icode is used for counting, every 20ms is a bit  
    chan.icode = ims; % 1 code = 1 ms  

    chan.codeCA = chan.ca(fix(chan.code_phase)+1)*2-1;  
%     chan.dataBit = bitand(bitshift(chan.dwrd(chan.iword+1), -(29-chan.ibit)), 1)*2-1;  
    chan.dataBit = (bitand(bitshift(chan.dwrd(chan.iword + 1), chan.ibit-29), 2^0) == 2^0) * 2 - 1; % (int)((chan[i].dwrd[chan[i].iword]>>(29-chan[i].ibit)) & 0x1UL)*2-1;  
%     fprintf('ms %f, iword %f, ibit %f, chan.dataBit£º%d\n', ms, chan.iword, chan.ibit, chan.dataBit);
    % Save current pseudorange  
    chan.rho0 = rho1;  
end
