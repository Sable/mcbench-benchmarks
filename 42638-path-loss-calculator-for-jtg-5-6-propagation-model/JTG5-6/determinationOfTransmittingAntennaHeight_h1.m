function [ h_1 ] = determinationOfTransmittingAntennaHeight_h1( h_eff, h_a, d )
%% Determine h1 based on § 3 of Annex 5 of ITU-R P. 1546-4

if h_eff == 0
    h_1 = h_a;
else
    if d <= 3
        h_1 = h_a;
    elseif d > 3 && d < 15
        h_1 = h_a + (h_eff - h_a)*(d-3)/12;
    else
        h_1 = h_eff;
    end
end
end

