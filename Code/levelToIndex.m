function [jStart, jEnd] = levelToIndex (ind, ii)
    % This function extracts indices stored in arrays of the kind ind(2,:). The matrix ind
    % can be seen as a multi-valued function, where for every index ind(1,ii) we associate
    % all the values ind(2,k) whenever ind(1,k)=ind(1,ii). The function levelToIndex gives
    % the indices k for which ind(1,ii)=ind(1,k). In particular, jStart is the minimum of
    % such k and jEnd is the maximum.

    arguments
        ind(2,:) {mustBeInteger}
        ii {mustBeInteger}
    end
    j=1;
            counterStart = 0;
            counterEnd = 0;
            while j<= length(ind) && counterEnd==0
                if(ii==ind(1,j) && counterStart == 0)
                    jStart=j;
                    counterStart = counterStart +1 ;
                end
                if(ii~=ind(1,j) && counterStart ~=0)
                jEnd=j-1;
                counterEnd = counterEnd +1 ;
                end
                j=j+1;
            end 

end