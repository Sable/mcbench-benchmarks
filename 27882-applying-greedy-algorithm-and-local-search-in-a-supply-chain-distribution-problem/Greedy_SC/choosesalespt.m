function [selectedsp,maxlostsales] = choosesalespt(lostdemandcost,salespoint,nosp)
maxlostsales = 0;
currentlostsales = 0;
for i = 1:nosp
    if (salespoint{i}(1,1)==0)
        currentlostsales = salespoint{i}(1,2)*lostdemandcost(i);
        if (currentlostsales >= maxlostsales)
            maxlostsales = currentlostsales;
            selectedsp = i;
        end
    end
end