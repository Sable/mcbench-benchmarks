function [ C ] = correctionForReceivingAntennaHeight(urban_suburban_rural, land_sea, rFreq, rDist, rHTx, rHRx )
%correctionForReceivingAntennaHeight Step 14:  Correct the field strength for receiving/mobile antenna height
% h2 using the method given in Annex 5, § 9. 
if land_sea == 2
    if rHRx < 10
        d10 = D06(rFreq, rHTx, 10);
        if rDist < d10
            dh2 = D06(rFreq, rHTx, 10);
            if rDist > dh2
                Rp = 10;
                Kh2 = 3.2 +6.2 *log10(rFreq);
                C10 = Kh2 * log10(rHRx/Rp);
                C = C10 * log10(rDist/dh2)/log10(d10/dh2);
            else
                C = 0;
            end
        else
            Rp = 10;
            Kh2 = 3.2 +6.2 *log10(rFreq);
            C = Kh2 * log10(rHRx/Rp);
        end
    else
        Rp = 10;
        Kh2 = 3.2 +6.2 *log10(rFreq);
        C = Kh2 * log10(rHRx/Rp);
    end
else
    if urban_suburban_rural == 1
        Rp = (1000*rDist*20)/(1000*rDist-15);
        if Rp < 1
            Disp('error')
            error
        else
            if Rp > rHRx
                h_dif = Rp-rHRx;
                theta_clut = atan(h_dif/27)/pi*180;
                K_nu = 0.0108*sqrt(rFreq);
                v = K_nu*sqrt(h_dif*theta_clut);
                Jv = 6.9 + 20*log10(sqrt((v-0.1)^2+1)+v-0.1);
                C = 6.03 -Jv;
            else
                Kh2 = 3.2 +6.2 *log10(rFreq);
                C = Kh2 * log10(rHRx/Rp);
            end
            if Rp <10 
                C = C - Kh2 * log10(10/Rp);
            end
        end
    else
        Rp = 10;
        Kh2 = 3.2 +6.2 *log10(rFreq);
        C = Kh2 * log10(rHRx/Rp);
    end    
end
end

