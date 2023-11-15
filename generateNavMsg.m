function [result, chan] = generateNavMsg(g, chan, init, sysConfig)  
% g: gpstime_t type variable  
% chan: channel_t type pointer  
% init: integer flag  
  
    % Define variables  
    g0.week = g.week;  
    g0.sec = double(uint32(g.sec+0.5)/30) * 30.0; % Align with the full frame length = 30 sec  
    chan.g0 = g0; % Data bit reference time  
    wn = uint32(rem(g0.week,1024));  
    tow = uint32(uint32(g0.sec)/6);  
  
    % Initialize subframe 5  
    if init == 1  
        prevwrd = uint32(0);  
        for iwrd = 0:sysConfig.N_DWRD_SBF-1  
            sbfwrd = chan.sbf(5, iwrd + 1);  
            % Add TOW-count message into HOW  
            if iwrd == 1  
                sbfwrd = bitor(sbfwrd, bitshift(bitand(tow,hex2dec('1FFFF')), 13));  
            end  
            % Compute checksum  
            sbfwrd = bitor(sbfwrd, bitand(bitshift(prevwrd, 30) , hex2dec('C0000000'))); % 2 LSBs of the previous transmitted word  
            nib = (iwrd == 1 | iwrd == 9); % Non-information bearing bits for word 2 and 10  
            chan.dwrd(iwrd + 1) = computeChecksum(sbfwrd, nib);  
            prevwrd = chan.dwrd(iwrd + 1);  
        end  
    else
        for iwrd = 0:sysConfig.N_DWRD_SBF-1  
            chan.dwrd(iwrd + 1) = uint32(chan.dwrd(sysConfig.N_DWRD_SBF*sysConfig.N_SBF+iwrd + 1));  
            prevwrd = chan.dwrd(iwrd + 1);  
        end  
        % Sanity check (commented out)  
        % if ((chan.dwrd(1)&(0x1FFFF<<13)) ~= ((tow&0x1FFFF)<<13))  
        %     fprintf(stderr, "\nWARNING: Invalid TOW in subframe 5.\n");  
        %     return(0);  
        % end  
    end  
  
    for isbf = 0:sysConfig.N_SBF-1  
        tow = tow + 1;  
        for iwrd = 0:sysConfig.N_DWRD_SBF-1  
            sbfwrd = uint32(chan.sbf(isbf + 1, iwrd + 1));  
            % Add transmission week number to Subframe 1  
            if ((isbf==0)&&(iwrd==2))  
                sbfwrd = bitor(sbfwrd, bitshift(bitand(wn,hex2dec('3FF')), 20));  
            end  
            % Add TOW-count message into HOW  
            if iwrd == 1  
                sbfwrd = bitor(sbfwrd, bitshift(bitand(tow, hex2dec('1FFFF')), 13));  
            end  
            % Compute checksum  
            sbfwrd = bitor(sbfwrd, bitand(bitshift(prevwrd, 30) , hex2dec('C0000000'))); % 2 LSBs of the previous transmitted word  
            nib = (iwrd == 1 || iwrd == 9); % Non-information bearing bits for word 2 and 10  
            chan.dwrd((isbf+1)*sysConfig.N_DWRD_SBF+iwrd + 1) = computeChecksum(sbfwrd, nib);  
            prevwrd = chan.dwrd((isbf+1)*sysConfig.N_DWRD_SBF+iwrd + 1);  
        end  
    end  
    result = 1;  
end