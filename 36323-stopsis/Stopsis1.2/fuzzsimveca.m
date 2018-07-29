function Sstar=fuzzysimveca(FDMNW,FPIS,n,simi)

for i=1:n
    if simi==1
        Sstar(i)=fsimil3([FDMNW{i}(1:4) 1],[FPIS{i}(1:4) 1]);
    elseif simi==2
        Sstar(i)=fsimil4a([FDMNW{i}(1:4) 1],[FPIS{i}(1:4) 1]);
    elseif simi==3
        Sstar(i)=fsimil1([FDMNW{i}(1:4) 1],[FPIS{i}(1:4) 1]);
    elseif simi==4
        Sstar(i)=fsimil2([FDMNW{i}(1:4) 1],[FPIS{i}(1:4) 1]);
    end
end