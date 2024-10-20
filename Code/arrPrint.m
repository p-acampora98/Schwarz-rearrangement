function arrPrint (arr)
        shortArr = round(arr,2);
        fprintf('[%s]\n', join(string(shortArr),', '));
end