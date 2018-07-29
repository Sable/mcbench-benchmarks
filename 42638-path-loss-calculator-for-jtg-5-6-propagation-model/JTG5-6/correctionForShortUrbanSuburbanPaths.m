function [ C ] = correctionForShortUrbanSuburbanPaths(urban_suburban_rural, rFreq, rDist, h_1, h_a )
%correctionForShortUrbanSuburbanPaths Step 15:  If applicable, reduce the field strength by adding the
% correction for short urban/suburban paths using the method given in Annex
% 5, § 10.
    if urban_suburban_rural ==1
        Rp = 20;
    else
        Rp = 10;
    end
    
    if rDist < 15 && h_1 - Rp < 150 && h_1 > Rp
        C = (-3.3*log10(rFreq))*(1- 0.85*log10(rDist))*(1-0.46*log10(1+h_a - Rp));
    else
        C = 0;
    end
end

