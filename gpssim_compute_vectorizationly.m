format long
dbstop if error
clear;
sysConfig.MAX_SAT  = 10; %32
sysConfig.MAX_CHAN = 2; %11
sysConfig.MAX_CHAR = 100;
sysConfig.USER_MOTION_SIZE = 3000; %// max duration at 10Hz
sysConfig.STATIC_MAX_DURATION = 86400; %// second
sysConfig.N_SBF = 5; %// 5 subframes per frame
sysConfig.N_DWRD_SBF = 10; %// 10 word per subframe
sysConfig.N_DWRD = (sysConfig.N_SBF+1)*sysConfig.N_DWRD_SBF; %// Subframe word buffer size
sysConfig.CA_SEQ_LEN = 1023;
sysConfig.SECONDS_IN_WEEK = 604800.0;
sysConfig.SECONDS_IN_HALF_WEEK = 302400.0;
sysConfig.SECONDS_IN_DAY = 86400.0;
sysConfig.SECONDS_IN_HOUR = 3600.0;
sysConfig.SECONDS_IN_MINUTE = 60.0;
sysConfig.POW2_M5  = 0.03125;
sysConfig.POW2_M19 = 1.907348632812500e-6;
sysConfig.POW2_M29 = 1.862645149230957e-9;
sysConfig.POW2_M31 = 4.656612873077393e-10;
sysConfig.POW2_M33 = 1.164153218269348e-10;
sysConfig.POW2_M43 = 1.136868377216160e-13;
sysConfig.POW2_M55 = 2.775557561562891e-17;
sysConfig.POW2_M50 = 8.881784197001252e-016;
sysConfig.POW2_M30 = 9.313225746154785e-010;
sysConfig.POW2_M27 = 7.450580596923828e-009;
sysConfig.POW2_M24 = 5.960464477539063e-008;
sysConfig.GM_EARTH = 3.986005e14;
sysConfig.OMEGA_EARTH = 7.2921151467e-5;
sysConfig.PI = 3.1415926535898;
sysConfig.WGS84_RADIUS = 6378137.0;
sysConfig.WGS84_ECCENTRICITY = 0.0818191908426;
sysConfig.R2D = 57.2957795131;
sysConfig.SPEED_OF_LIGHT = 2.99792458e8;
sysConfig.CARR_FREQ = 1575.42e6; % 此处为何是固定的�?
sysConfig.LAMBDA_L1 = sysConfig.SPEED_OF_LIGHT/sysConfig.CARR_FREQ;
sysConfig.CODE_FREQ = 1.023e6;
sysConfig.CARR_TO_CODE = sysConfig.CODE_FREQ/sysConfig.CARR_FREQ; % 此处为何是固定的�?
sysConfig.SC01 = 1;
sysConfig.SC08 = 8;
sysConfig.SC16 = 16;
sysConfig.EPHEM_ARRAY_SIZE = 13; %// for daily GPS broadcast ephemers file (brdc)
sysConfig.FALSE = 0;
sysConfig.TRUE  = 1;

sinTable512 = [
	   2,   5,   8,  11,  14,  17,  20,  23,  26,  29,  32,  35,  38,  41,  44,  47,...
	  50,  53,  56,  59,  62,  65,  68,  71,  74,  77,  80,  83,  86,  89,  91,  94,...
	  97, 100, 103, 105, 108, 111, 114, 116, 119, 122, 125, 127, 130, 132, 135, 138,...
	 140, 143, 145, 148, 150, 153, 155, 157, 160, 162, 164, 167, 169, 171, 173, 176,...
	 178, 180, 182, 184, 186, 188, 190, 192, 194, 196, 198, 200, 202, 204, 205, 207,...
	 209, 210, 212, 214, 215, 217, 218, 220, 221, 223, 224, 225, 227, 228, 229, 230,...
	 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 241, 242, 243, 244, 244, 245,...
	 245, 246, 247, 247, 248, 248, 248, 249, 249, 249, 249, 250, 250, 250, 250, 250,...
	 250, 250, 250, 250, 250, 249, 249, 249, 249, 248, 248, 248, 247, 247, 246, 245,...
	 245, 244, 244, 243, 242, 241, 241, 240, 239, 238, 237, 236, 235, 234, 233, 232,...
	 230, 229, 228, 227, 225, 224, 223, 221, 220, 218, 217, 215, 214, 212, 210, 209,...
	 207, 205, 204, 202, 200, 198, 196, 194, 192, 190, 188, 186, 184, 182, 180, 178,...
	 176, 173, 171, 169, 167, 164, 162, 160, 157, 155, 153, 150, 148, 145, 143, 140,...
	 138, 135, 132, 130, 127, 125, 122, 119, 116, 114, 111, 108, 105, 103, 100,  97,...
	  94,  91,  89,  86,  83,  80,  77,  74,  71,  68,  65,  62,  59,  56,  53,  50,...
	  47,  44,  41,  38,  35,  32,  29,  26,  23,  20,  17,  14,  11,   8,   5,   2,...
	  -2,  -5,  -8, -11, -14, -17, -20, -23, -26, -29, -32, -35, -38, -41, -44, -47,...
	 -50, -53, -56, -59, -62, -65, -68, -71, -74, -77, -80, -83, -86, -89, -91, -94,...
	 -97,-100,-103,-105,-108,-111,-114,-116,-119,-122,-125,-127,-130,-132,-135,-138,...
	-140,-143,-145,-148,-150,-153,-155,-157,-160,-162,-164,-167,-169,-171,-173,-176,...
	-178,-180,-182,-184,-186,-188,-190,-192,-194,-196,-198,-200,-202,-204,-205,-207,...
	-209,-210,-212,-214,-215,-217,-218,-220,-221,-223,-224,-225,-227,-228,-229,-230,...
	-232,-233,-234,-235,-236,-237,-238,-239,-240,-241,-241,-242,-243,-244,-244,-245,...
	-245,-246,-247,-247,-248,-248,-248,-249,-249,-249,-249,-250,-250,-250,-250,-250,...
	-250,-250,-250,-250,-250,-249,-249,-249,-249,-248,-248,-248,-247,-247,-246,-245,...
	-245,-244,-244,-243,-242,-241,-241,-240,-239,-238,-237,-236,-235,-234,-233,-232,...
	-230,-229,-228,-227,-225,-224,-223,-221,-220,-218,-217,-215,-214,-212,-210,-209,...
	-207,-205,-204,-202,-200,-198,-196,-194,-192,-190,-188,-186,-184,-182,-180,-178,...
	-176,-173,-171,-169,-167,-164,-162,-160,-157,-155,-153,-150,-148,-145,-143,-140,...
	-138,-135,-132,-130,-127,-125,-122,-119,-116,-114,-111,-108,-105,-103,-100, -97,...
	 -94, -91, -89, -86, -83, -80, -77, -74, -71, -68, -65, -62, -59, -56, -53, -50,...
	 -47, -44, -41, -38, -35, -32, -29, -26, -23, -20, -17, -14, -11,  -8,  -5,  -2];

 cosTable512 = [
	 250, 250, 250, 250, 250, 249, 249, 249, 249, 248, 248, 248, 247, 247, 246, 245,...
	 245, 244, 244, 243, 242, 241, 241, 240, 239, 238, 237, 236, 235, 234, 233, 232,...
	 230, 229, 228, 227, 225, 224, 223, 221, 220, 218, 217, 215, 214, 212, 210, 209,...
	 207, 205, 204, 202, 200, 198, 196, 194, 192, 190, 188, 186, 184, 182, 180, 178,...
	 176, 173, 171, 169, 167, 164, 162, 160, 157, 155, 153, 150, 148, 145, 143, 140,...
	 138, 135, 132, 130, 127, 125, 122, 119, 116, 114, 111, 108, 105, 103, 100,  97,...
	  94,  91,  89,  86,  83,  80,  77,  74,  71,  68,  65,  62,  59,  56,  53,  50,...
	  47,  44,  41,  38,  35,  32,  29,  26,  23,  20,  17,  14,  11,   8,   5,   2,...
	  -2,  -5,  -8, -11, -14, -17, -20, -23, -26, -29, -32, -35, -38, -41, -44, -47,...
	 -50, -53, -56, -59, -62, -65, -68, -71, -74, -77, -80, -83, -86, -89, -91, -94,...
	 -97,-100,-103,-105,-108,-111,-114,-116,-119,-122,-125,-127,-130,-132,-135,-138,...
	-140,-143,-145,-148,-150,-153,-155,-157,-160,-162,-164,-167,-169,-171,-173,-176,...
	-178,-180,-182,-184,-186,-188,-190,-192,-194,-196,-198,-200,-202,-204,-205,-207,...
	-209,-210,-212,-214,-215,-217,-218,-220,-221,-223,-224,-225,-227,-228,-229,-230,...
	-232,-233,-234,-235,-236,-237,-238,-239,-240,-241,-241,-242,-243,-244,-244,-245,...
	-245,-246,-247,-247,-248,-248,-248,-249,-249,-249,-249,-250,-250,-250,-250,-250,...
	-250,-250,-250,-250,-250,-249,-249,-249,-249,-248,-248,-248,-247,-247,-246,-245,...
	-245,-244,-244,-243,-242,-241,-241,-240,-239,-238,-237,-236,-235,-234,-233,-232,...
	-230,-229,-228,-227,-225,-224,-223,-221,-220,-218,-217,-215,-214,-212,-210,-209,...
	-207,-205,-204,-202,-200,-198,-196,-194,-192,-190,-188,-186,-184,-182,-180,-178,...
	-176,-173,-171,-169,-167,-164,-162,-160,-157,-155,-153,-150,-148,-145,-143,-140,...
	-138,-135,-132,-130,-127,-125,-122,-119,-116,-114,-111,-108,-105,-103,-100, -97,...
	 -94, -91, -89, -86, -83, -80, -77, -74, -71, -68, -65, -62, -59, -56, -53, -50,...
	 -47, -44, -41, -38, -35, -32, -29, -26, -23, -20, -17, -14, -11,  -8,  -5,  -2,...
	   2,   5,   8,  11,  14,  17,  20,  23,  26,  29,  32,  35,  38,  41,  44,  47,...
	  50,  53,  56,  59,  62,  65,  68,  71,  74,  77,  80,  83,  86,  89,  91,  94,...
	  97, 100, 103, 105, 108, 111, 114, 116, 119, 122, 125, 127, 130, 132, 135, 138,...
	 140, 143, 145, 148, 150, 153, 155, 157, 160, 162, 164, 167, 169, 171, 173, 176,...
	 178, 180, 182, 184, 186, 188, 190, 192, 194, 196, 198, 200, 202, 204, 205, 207,...
	 209, 210, 212, 214, 215, 217, 218, 220, 221, 223, 224, 225, 227, 228, 229, 230,...
	 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 241, 242, 243, 244, 244, 245,...
	 245, 246, 247, 247, 248, 248, 248, 249, 249, 249, 249, 250, 250, 250, 250, 250];
 
ant_pat_db = [
	 0.00,  0.00,  0.22,  0.44,  0.67,  1.11,  1.56,  2.00,  2.44,  2.89,  3.56,  4.22,...
	 4.89,  5.56,  6.22,  6.89,  7.56,  8.22,  8.89,  9.78, 10.67, 11.56, 12.44, 13.33,...
	14.44, 15.56, 16.67, 17.78, 18.89, 20.00, 21.33, 22.67, 24.00, 25.56, 27.33, 29.33,...
	31.56];
 
elvmask = 0.0;
% staticLocationMode = FALSE;
timeoverwrite      = sysConfig.FALSE;
samp_freq          = 10.23e6;
data_format        = sysConfig.SC16;
g0.week            = -1;
iduration          = sysConfig.USER_MOTION_SIZE;
duration           = double(iduration)/10.0;
verb               = sysConfig.FALSE;
ionoutc.enable     = sysConfig.TRUE;

navfile = 'files/brdc1840.23n';

% strcpy(umfile, optarg);
% nmeaGGA = FALSE;
% umLLH = FALSE;

staticLocationMode = sysConfig.TRUE;
% sscanf(optarg,"%lf,%lf,%lf",&llh[0],&llh[1],&llh[2]);
llh = [1.378898, 103.807031, 100];
llh(1:2) = llh(1:2) / sysConfig.R2D; 
% xyz = llh2xyz(llh);

% outfile = 
% duration = atof(optarg);
times = 10.0; % 100.0, 1000.0

iduration    = fix(duration*times + 0.5);
samp_freq    = floor(samp_freq/times);
iq_buff_size = samp_freq;
samp_freq    = samp_freq*times;

delt         = 1.0/samp_freq;

fprintf('Using static location mode.\n');
numd         = iduration;
% numd         = 2;
xyz = llh2xyz(llh, sysConfig);

fprintf('xyz = %11.1f, %11.1f, %11.1f\n', xyz(1,1), xyz(1,2), xyz(1,3));
fprintf('llh = %11.6f, %11.6f, %11.1f\n', llh(1)*sysConfig.R2D, llh(2)*sysConfig.R2D, llh(3));

[neph,  eph, ionoutc] = readRinexNavAll(navfile, ionoutc, sysConfig);
% eph = eph(1:sysConfig.MAX_CHAN, :);

if (neph == 0 )	
    fprintf('ERROR: No ephemeris available.\n');    
elseif (neph == -1)
    fprintf('ERROR: ephemeris file not found.\n');
end

for sv = 1:sysConfig.MAX_SAT
	if (eph(1, sv).vflg==1)
        gmin = eph(1, sv).toc;
        tmin = eph(1, sv).t;
        break;
    end
end

gmax.sec = 0;
gmax.week = 0;
tmax.sec = 0;
tmax.mm = 0;
tmax.hh = 0;
tmax.d = 0;
tmax.m = 0;
tmax.y = 0;

for sv = 1:sysConfig.MAX_SAT
    if (eph(neph,sv).vflg == 1)
         gmax= eph(1, sv).toc;
         tmax = eph(1, sv).t;
        break;
    end    
end

% Scenario start time has been set
if (g0.week>=0) 
    if (timeoverwrite==sysConfig.TRUE)
%         gtmp.week = g0.week;
%         gtmp.sec = fix(g0.sec)/7200.0 *7200.0;
%         dsec = subGpsTime(gtmp, gmin);
%         
%         ionoutc.wnt = gtmp.week;
%         ionoutc.tot = gtmp.sec;
    else
        if (subGpsTime(g0, gmin)<0.0 || subGpsTime(gmax, g0)<0.0)
            fprintf('Error!\n');
        end
    end 
else
    g0 = gmin;
    t0 = tmin;
end

fprintf('Start time = %4d/%02d/%02d,%02d:%02d:%02.0f (%d:%.0f)\n',... 
		t0.y, t0.m, t0.d, t0.hh, t0.mm, t0.sec, g0.week, g0.sec);
fprintf('Duration = %.1f [sec]\n', numd/10.0);

ieph = -1;
for i = 1:neph
     for sv = 1:sysConfig.MAX_SAT
        if (eph(i,sv).vflg == 1)		
            dt = subGpsTime(g0, eph(i,sv).toc, sysConfig);
            if (dt >= -sysConfig.SECONDS_IN_HOUR && dt < sysConfig.SECONDS_IN_HOUR)
                ieph = i;
                break;
            end
        end
     end
     if (ieph>0) % ieph has been set
        break;
     end
end

if (ieph == -1)
    fprintf('ERROR: No current set of ephemerides has been found.\n');
end

iq_buff = int16(NaN(1, 2*iq_buff_size));

% Setup all channels
chan = repmat(struct('prn',int32(0), 'ca',zeros(1, sysConfig.CA_SEQ_LEN), ...
    'f_carr',0.0, 'f_code',0.0, 'carr_phase',int32(0), 'code_phase',0.0, ...
    'g0',0, 'sbf',zeros(5, sysConfig.N_DWRD_SBF), 'dwrd',zeros(1, sysConfig.N_DWRD), ...
    'iword',0, 'ibit',0, 'icode',0, 'dataBit',0, 'codeCA',0, 'azel',zeros(1, 2), 'rho0',0), ...
    1, sysConfig.MAX_CHAN);  

% Clear satellite allocation flag
allocatedSat(1:sysConfig.MAX_SAT) = -1;
% Initial reception time
grx = incGpsTime(g0, 0.0, sysConfig);
% Allocate visible satellites
[~, chan, allocatedSat]= allocateChannel(chan, eph(ieph,:), ionoutc, grx, xyz(1,:), allocatedSat, sysConfig);

for i = 1:sysConfig.MAX_CHAN
    if (chan(i).prn>0)
        fprintf(2, '%02d %6.1f %5.1f %11.1f %5.1f\n', chan(i).prn,... 
            chan(i).azel(1)*sysConfig.R2D, chan(i).azel(2)*sysConfig.R2D,...
            chan(i).rho0.d, chan(i).rho0.iono_delay);
    end
end

ant_pat = NaN(1, 37);
for i = 1:37  
    ant_pat(i) = 10.0^(-ant_pat_db(i)/20.0);  
end

tic
% Update receiver time
grx = incGpsTime(grx, 1/times, sysConfig);
gain = NaN(1, sysConfig.MAX_CHAN);
for iumd = 1:numd - 1
    for i = 1:sysConfig.MAX_CHAN
          if chan(i).prn > 0  
              % Refresh code phase and data bit counters  
    %           rho = struct('azel', zeros(1, 2)); % Initialize rho with azel field  
                sv = chan(i).prn;  
                % Current pseudorange  
                if ~staticLocationMode  
                    rho = computeRange(eph(ieph, sv), ionoutc, grx, xyz(iumd + 1,:), sysConfig);  
                else  
                    rho = computeRange(eph(ieph, sv), ionoutc, grx, xyz(1,:), sysConfig);  
                end  
                chan(i).azel(1) = rho.azel(1); 
                chan(i).azel(2) = rho.azel(2);
                % Update code phase and data bit counters  
                chan(i) = computeCodePhase(chan(i), rho, 1/times, sysConfig);  
                chan(i).carr_phasestep = int32(fix(round(512.0 * 65536.0 * chan(i).f_carr * delt)));
                % Path loss  
                path_loss = 20200000.0 / rho.d;  
                % Receiver antenna gain  
                ibs = fix((90.0 - rho.azel(2) * sysConfig.R2D) / 5.0); % covert elevation to boresight  
                ant_gain = ant_pat(ibs + 1);  
                % Signal gain  
                gain(i) = fix(path_loss * ant_gain * 128.0); % scaled by 2^7  
           end
    end
    
                    samp_idx = 1:iq_buff_size;
                %     chan_idx = chan(i).prn > 0;
                    chan_idx = 1:sysConfig.MAX_CHAN;  
                    carr_phase = chan(chan_idx).carr_phase + (samp_idx - 1).*chan(chan_idx).carr_phasestep;
                    iTable = bitand(bitshift(carr_phase, -16) , 511); % 511 == 0x1ff
                    % Compute ip and qp  
%                   ip = chan(i).dataBit * chan(i).codeCA * cosTable512(iTable + 1) * gain(i);  
%                   qp = chan(i).dataBit * chan(i).codeCA * sinTable512(iTable + 1) * gain(i);  

                    ip = chan(i).dataBit * chan(i).codeCA .* cosTable512(iTable + 1);
                    qp = chan(i).dataBit * chan(i).codeCA .* sinTable512(iTable + 1);
                    
                    % Accumulate for all visible satellites  
                    i_acc = sum(ip, 1);    
                    q_acc = sum(qp, 1);  

                    % Update code phase  
                    chan(chan_idx).code_phase = chan(chan_idx).code_phase + (samp_idx - 1).*chan(chan_idx).f_code * delt;  
                    % Post process of code phase
                    chan(chan_idx).code_phase = mod(chan(chan_idx).code_phase + code_phase_add, sysConfig.CA_SEQ_LEN);  

                    chan(chan_idx).icode = mod(chan(chan_idx).icode + (code_phase_add >= sysConfig.CA_SEQ_LEN), 20);  
                    chan(chan_idx).ibit = mod(chan(chan_idx).ibit + (chan(chan_idx).icode >= 20), 30);  
                    chan(chan_idx).iword = mod(chan(chan_idx).iword + (chan(chan_idx).ibit >= 30), sysConfig.NAV_DATA_BITS / 30);  
                    chan(chan_idx).dataBit = bitshift(chan(chan_idx).dwrd(chan(chan_idx).iword + 1), -(29 - chan(chan_idx).ibit)) * 2 - 1; % (int)((chan[i].dwrd[chan[i].iword]>>(29-chan[i].ibit)) & 0x1UL)*2-1;    
                    chan(chan_idx).codeCA = chan(chan_idx).ca(fix(chan(chan_idx).code_phase + 1)) * 2 - 1;   

                    % Update carrier phase  
%                    FLOAT_CARR_PHASE
%                     chan(i).carr_phase = chan(i).carr_phase + chan(i).f_carr * delt;  
%                     if chan(i).carr_phase >= 1.0  
%                         chan(i).carr_phase = chan(i).carr_phase - 1.0;  
%                     elseif chan(i).carr_phase < 0.0  
%                         chan(i).carr_phase = chan(i).carr_phase + 1.0;  
%                     end  

                    chan(i).carr_phase = chan(i).carr_phase + chan(i).carr_phasestep;  
%                 end  
                % Scaled by 2^7  
%                 i_acc = bitshift(int32(i_acc + 64), -7); % (i_acc+64)>>7;  
%                 q_acc = bitshift(int32(q_acc + 64), -7); % (i_acc+64)>>7;  
%                  i_acc = bitshift((int32(i_acc) + 64), -7);  
%                  q_acc = bitshift((int32(q_acc) + 64), -7);  
                  iq_buff(isamp*2 + 1) = i_acc;
                  iq_buff(isamp*2 + 2) = q_acc;
                 
%   fprintf('grx.sec��%f\n', grx.sec);
    igrx = int32(grx.sec*times + 0.5);
    if mod(igrx,0.02*times) == 0 % Every 30 seconds
        % Update navigation message  
        for i = 1:sysConfig.MAX_CHAN  
            if chan(i).prn > 0  
                generateNavMsg(grx, chan(i), 0, sysConfig);  
            end  
        end  
        % Refresh ephemeris and subframes  
        % Quick and dirty fix. Need more elegant way.  
        for sv = 1:sysConfig.MAX_SAT  
            if eph(ieph+2,sv).vflg == 1  
                dt = subGpsTime(eph(ieph+2,sv).toc, grx, sysConfig);  
                if dt < sysConfig.SECONDS_IN_HOUR  
                    ieph = ieph + 1;  
                    for i = 1:sysConfig.MAX_CHAN  
                        % Generate new subframes if allocated  
                        if chan(i).prn ~= 0   
                            chan(i).sbf = uint32(eph2sbf(eph(ieph+1, chan(i).prn-1), ionoutc));  
                        end  
                    end  
                end  
                break;  
            end  
        end  

        % Update channel allocation  
        if ~staticLocationMode  
            [~, chan, allocatedSat] = allocateChannel(chan, eph(ieph+1,:), ionoutc, grx, xyz(iumd + 1,:), allocatedSat, sysConfig);  
        else  
            [~, chan, allocatedSat] = allocateChannel(chan, eph(ieph+1,:), ionoutc, grx, xyz(1,:), allocatedSat, sysConfig);  
        end  

        % Show details about simulated channels  
        if verb == sysConfig.TRUE  
            fprintf('\n');  
            for i = 1:sysConfig.MAX_CHAN  
                if chan(i).prn > 0  
                    fprintf('%02d %6.1f %5.1f %11.1f %5.1f\n', chan(i).prn, ...  
                        chan(i).azel(1)*sysConfig.R2D, chan(i).azel(2)*sysConfig.R2D,...
                        chan(i).rho0.d, chan(i).rho0.iono_delay);  
                end  
            end  
        end  
    end  
    
    % Update receiver time  
    grx = incGpsTime(grx, 1/times, sysConfig);  
    % Update time counter
%     if mod(igrx, 0.01*times) == 0 % Every 0.01 seconds  
    fprintf('\rTime into run = %4.3f\n', subGpsTime(grx, g0, sysConfig));
%     end
end

consume = toc;

fprintf(2, '\nDone!\n');
fprintf(2, 'Process time = %.1f [sec]\n', consume);

save iq_buff iq_buff
