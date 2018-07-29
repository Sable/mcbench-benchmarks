function [ d_mid ] = searchForDistance( E_wanted, freq, land_sea, urban_suburban_rural, h_a, h_eff, h_2, tPct, lPct, mobile, indoor, tx_erp )
%searchForDistanceLoss finds the distance at which a certain field strength
% value occurs occurs given a certain set of parameters for the JTG5-6
% model and a certain ERP value

d_upper = 1000;
d_lower = 0.01;
while 1
    d_mid = d_lower + (d_upper-d_lower)/2;
    E_mid = 139.3 - JTG5_6( freq , land_sea, urban_suburban_rural, h_a, h_eff, h_2, d_mid, tPct, lPct, mobile, indoor) + 20*log10(freq) + tx_erp;

    delta = abs(E_mid - E_wanted );
    if delta < 0.005
        break
    else
        if E_mid < E_wanted
            d_upper = d_mid;
        else
            d_lower = d_mid;
        end
    end
end
end

