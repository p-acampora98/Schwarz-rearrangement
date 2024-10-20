function [v, infim] = binaryClosest(arr, val)
    %vectorial version of binaryClosest1. Search in a sorted (increasing) array
    L=length(val);
    v=zeros(1,L);
    infim=zeros(1,L);
    for i=1:L
        [v(i),infim(i)]=binaryClosest1(arr, val(i));
    end
end
    