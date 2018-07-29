% JTG5_6  Path Loss Calculation based on Section 4.3 of Annex 9 to Document 5-6/180-E 
%
% Elements of the “Hata” model will be used for short (i.e. ? 0.1 km) distance 
% propagation predictions and elements of Recommendation ITU-R P.1546-3 for long 
% (i.e. ? 1 km) distances, with logarithmic interpolation connecting the two in 
% the transition range. Recommendation ITU-R P.1546-4 provides propagation predictions 
% in terms of “field strength” as a function of distance. The “Hata” model provides 
% propagation predictions in terms of “propagation loss” as a function of distance. 
% In order to be consistent with the units when using the “Hata” model at “short” 
% distances and Recommendation ITU-R P.1546-3 at “large” distances, with an 
% interpolation between “short” and “large” distances, the formula for the conversion 
% between field strength and propagation loss, is the following (assuming a 
% 0 dBkW ERP for the Recommendation ITU-R P.1546-3 tabulated predictions):
%		E(dBuV/m) = 139.3 + 20 log f(MHz) – Loss
% For consistency, field-strength values (dBuV/m units) are specified, converting 
% from the calculated propagation loss, using the above equation, in the cases where 
% the “Hata” model is applied.
%
% The “Hata” model indicated here and elsewhere in this text (with the word 
% Hata in single quotation marks) refers to the “Modified Hata” propagation 
% model described in Report ITU-R SM.2028-1.

%
%	Loss = JTG5_6( freq, land_sea, urban_suburban_rural, h_a, h_eff, h_2, distance, tPct, lPct, mobile, indoor  )
%
% where:            Units,      Definition                              Limits
%        freq:      MHz,        Operating frequency.                    600-2000 MHz
%
%       land_sea:   number      what type of field strength             1->'Land',2->'Sea'
%
%       urban_suburban_rural:   what type of land path                  1->'Urban',2->'Suburban', 3->'Rural'
%
%       ha:         m,          Transmitter antenna height above        >clutter m
%                               ground. Defined in Annex 5 sec 3.1.1.
%                               Limits are defined in Annex 5 sec 3, 
%                               ITU-R P. 1546-4.
%
%        h_eff:     m,          the effective height of the             >clutter m
%                               transmitting/base antenna, height over
%                               the average level of the ground between
%                               distances of 3 and 15 km from the
%                               transmitting/base antenna in the
%                               direction of the receiving/mobile antenna.
%
%       h_2:        m,          Receiving/mobile antenna height         Land – 1 m < h_2 < 3 000 m
%                               above ground. Defined in Annex 1        Sea –  3 m < h_2 < 3 000 m
%                               of ITU-R P. 1546-4.
%
%        distance:  km,         Path length.                            0-1000 km
%
%        tPct:      %,          Percentage time defined                 1-50 %
%
%        lPct:      %,          Percentage of locations defined         1-99 %
%
%       mobile:     boolean,    receiver is mobile or not     
%
%       indoor:     boolean,    receiver is indoors or not
%
%
% Ahmed Saeed, Egypt-Japan Univerity of Science and Technology, 2013.
%
% Numbers refer to Rec. ITU-R P.1546-4, Report ITU-R SM.2028-1 and Annex 9
% to Document 5-6/180-E.


function Loss = JTG5_6( freq, land_sea, urban_suburban_rural, h_a, h_eff, h_2, distance, tPct, lPct, mobile, indoor  )
%JTG5_6  Path Loss Calculation based on Section 4.3 of Annex 9 to Document 5-6/180-E 

%% Section 2.1 of Appendix 1 to Annex 2 of Rep.  ITU-R  SM.2028-1
% Case 1: distance < 0.04 use free space path loss model for the modified
% hata model. 
    if distance < 0.04
        Loss = 32.5 + 20*log10(freq)+20*log10(distance + (h_a - h_2)^2/10^6);
% For indoor scenarios the standard diviation of the path loss value is
% determined based on Case 1 of Section 2.2 of Appendix 1 to Annex 2 of Rep. ITU-R
% SM.2028-1 and the standard diviation of the building entry loss from
% Section 4.9 of Annex 1 of ITU-R P.1812-2. The calculations are based on
% Section 4 of Appendix 1 to Annex 2 of Rep. ITU-R SM.2028-1.
        if indoor
            Qi_x = (-norminv(lPct/100,0,1));
            Loss = Loss + 11 + Qi_x * sqrt(3.5^2+36);
        end
%% Section 2.1 of Appendix 1 to Annex 2 of Rep.  ITU-R  SM.2028-1
% Case 3: 0.04 km < distance < 0.1 km use free space path loss model for
% the modified hata model. 
    elseif distance < 0.1 && distance > 0.04
        loss_fs = 32.5 + 20*log10(freq)+20*log10(0.04 + (h_a - h_2)^2/10^6);
        loss_01 = modified_hata( freq, urban_suburban_rural, h_a, h_2, 0.1);
        
        Loss = loss_fs + ((log10(distance) - log10(0.04))/(log10(0.1) - log10(0.04)))*(loss_01 - loss_fs);
% For indoor scenarios the standard diviation of the path loss value is
% determined based on Case 2 of Section 2.2 of Appendix 1 to Annex 2 of
% Rep. ITU-R SM.2028-1 (where by indoor we mean below the roof and outdoors
% we mean above the roof) and the standard diviation of the building entry
% loss from  Section 4.9 of Annex 1 of ITU-R P.1812-2. The calculations are
% based on Section 4 of Appendix 1 to Annex 2 of Rep. ITU-R SM.2028-1.        
        if indoor
            if mobile
                segma = 3.5 + ((17-3.5)/(0.1-0.04))*(distance-0.04);
                Qi_x = (-norminv(lPct/100,0,1));
                Loss = Loss + 11 + Qi_x * sqrt(segma ^2+36);
            else
                segma = 3.5 + ((12-3.5)/(0.1-0.04))*(distance-0.04);
                Qi_x = (-norminv(lPct/100,0,1));
                Loss = Loss + 11 + Qi_x * sqrt(segma ^2+36);
            end
        end
%% Section 2.1 of Appendix 1 to Annex 2 of Rep.  ITU-R  SM.2028-1
% Case 2: distance >= 0.1 km use free space path loss model for
% the modified hata model. 
    elseif distance == 0.1
        Loss = modified_hata( freq, urban_suburban_rural, h_a, h_2, 0.1);
% For indoor scenarios the standard diviation of the path loss value is
% determined based on Case 2 of Section 2.2 of Appendix 1 to Annex 2 of
% Rep. ITU-R SM.2028-1 (where by indoor we mean below the roof and outdoors
% we mean above the roof) and the standard diviation of the building entry
% loss from  Section 4.9 of Annex 1 of ITU-R P.1812-2. The calculations are
% based on Section 4 of Appendix 1 to Annex 2 of Rep. ITU-R SM.2028-1.        
        if indoor
            if mobile
                segma = 3.5 + ((17-3.5)/(0.1-0.04))*(distance-0.04);
                Qi_x = (-norminv(lPct/100,0,1));
                Loss = Loss + 11 + Qi_x * sqrt(segma ^2+36);
            else
                segma = 3.5 + ((12-3.5)/(0.1-0.04))*(distance-0.04);
                Qi_x = (-norminv(lPct/100,0,1));
                Loss = Loss + 11 + Qi_x * sqrt(segma ^2+36);
            end
        end
%% Based on the definition of the JTG propagation model the Elements of the 
% “Hata” model will be used for short (i.e. ? 0.1 km) distance   
% propagation predictions and elements of Recommendation ITU-R P.1546-3 for
% long (i.e. ? 1 km) distances, with "logarithmic interpolation" connecting
% the two in  the transition range.
    elseif distance < 1 && distance > 0.1
        hata_100 = modified_hata( freq, urban_suburban_rural, h_a, h_2, 0.1);
        if indoor
            if mobile
                if distance <= 0.2 && distance > 0.1
                    segma = 17;
                elseif distance <= 0.6 && distance > 0.2
                    segma = 12 + ((9-17)/(0.6-0.2))*(distance-0.2);
                else
                    segma = 9;
                end
                Qi_x = (-norminv(lPct/100,0,1));
                hata_100 = hata_100 + 11 + Qi_x * sqrt(segma ^2+36);
            else
                if distance <= 0.2 && distance > 0.1
                    segma = 12;
                elseif distance <= 0.6 && distance > 0.2
                    segma = 12 + ((9-12)/(0.6-0.2))*(distance-0.2);
                else
                    segma = 9;
                end
                Qi_x = (-norminv(lPct/100,0,1));
                hata_100 = hata_100 + 11 + Qi_x * sqrt(segma ^2+36);
            end
        end
        itu1546_1000 = ITU1546_4(land_sea, urban_suburban_rural,freq, 1.0, h_eff, h_a, h_2, tPct, lPct, mobile, indoor);

        interpolation = (log10(distance) - log10(0.1)) / (log10(1) - log10(0.1));
        interpolation = interpolation * (itu1546_1000 - hata_100);

        Loss = hata_100 + interpolation;

    else
%% ITU-R P. 1546-4
        Loss = ITU1546_4(land_sea, urban_suburban_rural,freq, distance, h_eff, h_a, h_2, tPct, lPct, mobile, indoor);
    end
end