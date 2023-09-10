function c = countBits(v)  
    c = v;  
    S = [1, 2, 4, 8, 16];  
    B = [hex2dec('55555555'), hex2dec('33333333'), hex2dec('0F0F0F0F'),...
        hex2dec('00FF00FF'), hex2dec('0000FFFF')];  
    
    for i = 1:length(S)  
        c = bitand(bitshift(c, -S(i)), B(i)) + bitand(c, B(i));  
    end  
end