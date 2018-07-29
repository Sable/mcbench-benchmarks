function str = ConvertMFSK2RS(Str1)

for i = 1:length(Str1)
    if (Str1(i) == 0)
        str(i) = -Inf;
    else
        str(i) = Str1(i)-1;
    end
end