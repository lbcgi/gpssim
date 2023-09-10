function D = computeChecksum(source, nib)  
    % Define bit masks  
    bmask = [hex2dec('3B1F3480'), hex2dec('1D8F9A40'), hex2dec('2EC7CD00'), ...  
              hex2dec('1763E680'), hex2dec('2BB1F340'), hex2dec('0B7A89C0')];  
  
    % Extract D29 and D30 from source data bits  
    d = bitand(source , hex2dec('3FFFFFC0'));  
    D29 = bitand(bitshift(source , -31) , 1);  
    D30 = bitand(bitshift(source , -30) , 1);
  
    % Solve bits 23 and 24 to preserve parity check with zeros in bits 29 and 30  
    if nib  
        if mod(D30 + countBits(bitand(bmask(4) , d)) , 2) == 1  
            d = bitxor(d, 2^6);  
        end  
        if mod(D29 + countBits(bitand(bmask(5) , d)) , 2) == 1  
            d = bitxor(d, 2^7);  
        end  
    end  
  
    % Compute checksum bits  
    D = d;  
    if D30 ~= 0  
      D = bitxor(D, hex2dec('3FFFFFC0'));  
    end  
    D = bitor(D, bitshift(mod((D29 + countBits(bitand(bmask(1), d))), 2), 5));  
    D = bitor(D, bitshift(mod((D30 + countBits(bitand(bmask(2), d))), 2), 4));  
    D = bitor(D, bitshift(mod((D29 + countBits(bitand(bmask(3), d))), 2), 3));  
    D = bitor(D, bitshift(mod((D30 + countBits(bitand(bmask(4), d))), 2), 2));  
    D = bitor(D, bitshift(mod((D30 + countBits(bitand(bmask(4), d))), 2), 1));
    D = bitor(D, mod((D29 + countBits(bitand(bmask(4), d))), 2));  

    D = bitand(D, hex2dec('3FFFFFFF'));
end