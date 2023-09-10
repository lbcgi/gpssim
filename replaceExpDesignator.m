function str = replaceExpDesignator(str, len)
   
    for i = 1:len
    
        if (str(i)=='D')
              str(i) = 'E';
        end
        
    end