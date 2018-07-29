function str = ConvertRS2MFSK(Str1)

for i = 1:length(Str1)
    if (Str1(i) == -Inf)|(Str1(i) == -1)
        str(i) = 0;
    else
        str(i) = Str1(i)+1;
    end
end