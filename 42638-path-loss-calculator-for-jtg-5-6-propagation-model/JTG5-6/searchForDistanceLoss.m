function [ d_mid ] = searchForDistanceLoss( Loss_wanted, freq, land_sea, urban_suburban_rural, h_a, h_eff, h_2, tPct, lPct, mobile, indoor)
%searchForDistanceLoss finds the distance at which a certain loss value
%occurs given a certain set of parameters for the JTG5-6 model

d_upper = 1000;
d_lower = 0.001;
while 1
    d_mid = d_lower + (d_upper-d_lower)/2;
    Loss_mid = JTG5_6( freq , land_sea, urban_suburban_rural, h_a, h_eff, h_2, d_mid, tPct, lPct, mobile, indoor) ;%-tx_erp ;
    delta = abs(Loss_mid - Loss_wanted );
    if delta < 0.05
        break
    else
        if Loss_mid > Loss_wanted
            d_upper = d_mid;
        else
            d_lower = d_mid;
        end
    end
end
end

