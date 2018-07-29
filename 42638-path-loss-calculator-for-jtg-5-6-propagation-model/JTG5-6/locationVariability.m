function [ C] = locationVariability(urban_suburban_rural, rFreq, q, mobile, indoor)
%locationVariability Step 16:  If the field strength at a receiving/mobile antenna adjacent to
% land exceeded at percentage locations other than 50% is required, correct
% the field strength for the required percentage of locations using the
% method given in Annex 5, § 12.   

    Qi_x = (-norminv(q/100,0,1));
    if (urban_suburban_rural ==1 || urban_suburban_rural ==2) && mobile ==1
        K = 1.2;
    elseif (urban_suburban_rural ==1 || urban_suburban_rural ==2) && mobile ==0
        K = 1;
    else
        K = 0.5;
    end
    segma_L = K + 1.3* log10(rFreq);
    
%     if urban_suburban_rural ==3
%         segma_L = 5.5;
%     end
    %%%%%%%%%%%%%%%% remove this %%%%%%%%%%%%%%%%%%%%
    %segma_L = sqrt(5.5^2+5.5^2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if indoor
        segma_L = sqrt(segma_L^2+36);
    end
    
    C = Qi_x*segma_L ;
    
    %C = -9.05;
end

