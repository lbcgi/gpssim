function [nsat, chan, allocatedSat] = allocateChannel(chan, eph, ionoutc, grx, xyz, allocatedSat, sysConfig)  
    nsat = 0;  
    azel = zeros(1, 2);  
%   rho = struct('d', 0, 'range', 0, 'rate', 0, 'g', 0, 'azel', 0);  
    ref = zeros(1, 3);  
   
    for sv = 0:sysConfig.MAX_SAT-1  
%         fprintf('Debug:checkSatVisibility is %d\n',...
%             checkSatVisibility(eph(sv+1), grx, xyz, 0.0, azel, sysConfig) == 1); % Debug
        if checkSatVisibility(eph(sv+1), grx, xyz, 0.0, azel, sysConfig) == 1  
            nsat = nsat + 1; % Number of visible satellites  
  
                if allocatedSat(sv+1) == -1 % Visible but not allocated  
                    % Allocated new satellite  
                    for i = 0:sysConfig.MAX_CHAN-1  
                        if chan(i+1).prn == 0  
                            % Initialize channel
    %                         disp('Debug prn is:');
    %                         disp(sv + 1); % Debug
                            chan(i+1).prn = sv + 1;  
                            chan(i+1).azel(1) = azel(1);  
                            chan(i+1).azel(2) = azel(2);  

                            % C/A code generation  
                            chan(i+1).ca = codegen(chan(i+1).prn, sysConfig);  

                            % Generate subframe  
    %                         tic
    %                         chan(i+1).sbf = uint32(eph2sbf_dll(eph(sv+1), ionoutc));
    %                         t1 = toc
    %                         tic
                            chan(i+1).sbf = uint32(eph2sbf(eph(sv+1), ionoutc, sysConfig)); % �������uint32����Щ���� 
    %                         t2 = toc
                            % Generate navigation message                         
                            [~, chan(i+1)] = generateNavMsg(grx, chan(i+1), 1, sysConfig);                        
                            % Initialize pseudorange  
                            rho = computeRange(eph(sv+1), ionoutc, grx, xyz, sysConfig);  
                            chan(i+1).rho0 = rho;  

                            % Initialize carrier phase  
                            r_xyz = rho.range;  

                            rho = computeRange(eph(sv+1), ionoutc, grx, ref, sysConfig);  
                            r_ref = rho.range;  

                            phase_ini = (2.0*r_ref - r_xyz)/sysConfig.LAMBDA_L1;
                            phase_ini = phase_ini - fix(phase_ini);
                            %chan(i+1).carr_phase = int32(512.0 * 65536.0 * phase_ini); 
    %                       chan(i+1).carr_phase = 9926914;%Debug
                            chan(i+1).carr_phase = phase_ini;
                            % Done.  
                            break;  
                        end  
                    end  

                    % Set satellite allocation channel  
                    if i < sysConfig.MAX_CHAN  
                        allocatedSat(sv+1) = i;  
                    end 
                end
        elseif allocatedSat(sv+1) >= 0 % Not visible but allocated  
                % Clear channel  
            chan(allocatedSat(sv+1) + 1).prn = 0;  
                % Clear satellite allocation flag  
            allocatedSat(sv+1) = -1;  
        end  
      
end