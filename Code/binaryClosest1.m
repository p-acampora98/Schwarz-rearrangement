function [v, infim] = binaryClosest1(arr, val)
    % Returns value and index of arr that is closest to val. If several entries
    % are equally close, return the first. Works fine up to machine error (e.g.
    % [v, i] = closest_value([4.8, 5], 4.9) will return [5, 2], since in float
    % representation 4.9 is strictly closer to 5 than 4.8).
    % ===============
    % Parameter list:
    % ===============
    % arr : increasingly ordered array
    % val : scalar in R
    
    if (~issorted(arr))
        error('The array is not sorted');
    end
    
    len = length(arr);
    infim = 1;
    sup = len;
    
    % Binary search for index
    while sup - infim > 1
        med = floor((sup + infim)/2);
        
        % Replace >= here with > to obtain the last index instead of the first.
        if arr(med) >= val 
            sup = med;
        else
            infim = med;
        end
    end
    
    % Replace < here with <= to obtain the last index instead of the first.
    if sup - infim == 1 && abs(arr(sup) - val) < abs(arr(infim) - val)
        infim = sup;
    end  
    
    v = arr(infim);
    end
    

%  Benjamin Bernard (2024). Binary search for closest value in an array (https://www.mathworks.com/matlabcentral/fileexchange/37915-binary-search-for-closest-value-in-an-array), MATLAB Central File Exchange. Recuperato ottobre 21, 2024. 
