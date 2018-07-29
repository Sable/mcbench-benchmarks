function [ value ] = calculateFieldStrengthForAntennaHeight(Frequency, land_sea,  fieldStrengths, distance,antennaHeight, possibleAntennaHeights, tPct )
%calculateFieldStrengthForAntennaHeight Step 8:  Obtain the field strength exceeded at 50% locations for a
% receiving/mobile antenna at the height of representative clutter, R,
% above ground for the required distance and transmitting/base antenna
% height as follows:   
%	Step 8.1:  For a transmitting/base antenna height h1 equal to or
%	greater than 10 m follow Steps 8.1.1 to 8.1.6: 
%
%	Step 8.1.1:  Determine the lower and higher nominal h1 values using the
%	method given in Annex 5, § 4.1. If h1 coincides with one of the nominal
%	values 10, 20, 37.5, 75, 150, 300, 600 or 1 200 m, this should be
%	regarded as the lower nominal value of h1 and the interpolation process
%	of Step 8.1.6 is not required.    
%
%	Step 8.1.2:  For the lower nominal value of h1 follow Steps 8.1.3 to
%	8.1.5. 
%
%	Step 8.1.3:  For the lower nominal value of distance follow Step 8.1.4.
%
%	Step 8.1.4:  Obtain the field strength exceeded at 50% locations for a
%	receiving/mobile antenna at the height of representative clutter, R,
%	for the required values of distance, d, and transmitting/base antenna
%	height, h1.   
%
%	Step 8.1.5:  If the required distance does not coincide with the lower
%	nominal distance, repeat Step 8.1.4 for the higher nominal distance and
%	interpolate the two field strengths for distance using the method given
%	in Annex 5, § 5.   
%
%	Step 8.1.6:  If the required transmitting/base antenna height, h1, does
%	not coincide with one of the nominal values, repeat Steps 8.1.3 to
%	8.1.5 and interpolate/extrapolate for h1 using the method given in
%	Annex 5, § 4.1. If necessary limit the result to the maximum given in
%	Annex 5, § 2.    
%
%	Step 8.2: For a transmitting/base antenna height h1 less than 10 m
%	determine the field strength for the required height and distance using
%	the method given in Annex 5, § 4.2. If h1 is less than zero, the method
%	given in Annex 5, § 4.3 should also be used.    

upper_antenna_index = 1;
if possibleAntennaHeights (1) > antennaHeight
    if Frequency == 600
        Kv= 3.31;
    else
        Kv= 6;
    end
    Theta_eff2 = atan(10/9000)/pi*180;
    v = Kv*Theta_eff2;
    Jv = 6.9 + 20*log10(sqrt((v-0.1)^2+1)+v-0.1);
    C_h1neg10 = 6.03 - Jv;
    if land_sea ==1
        E10 = interploateFieldStrengthForDistance(fieldStrengths, distance, 1);
        E20 = interploateFieldStrengthForDistance(fieldStrengths, distance, 2);
        C1020 = E10-E20;
        Ezero = E10 + 0.5*(C1020+C_h1neg10);
        value = Ezero+0.1*antennaHeight*(E10-Ezero);
        return
    else
        Dh1 = D06(Frequency, antennaHeight,10);
        D20 = D06(Frequency,20,10);
        if distance <= Dh1
            efs = 106.9 - 20*log10(distance);
            ese = 2.38*(1-exp(-distance/8.94))*log10(50/tPct);
            value = efs+ese;
            return
        elseif distance > Dh1 && distance < D20
            E10D20 = calculateFieldStrengthForAntennaHeight(Frequency, land_sea,  fieldStrengths, D20,10, possibleAntennaHeights, tPct);
            
            E20D20 = calculateFieldStrengthForAntennaHeight(Frequency, land_sea,  fieldStrengths, D20,20, possibleAntennaHeights, tPct);
            
            ED20 = E10D20 +(E20D20-E10D20)*log10(antennaHeight/10)/log10(20/10);
            
            efs_dh1 = 106.9 - 20*log10(Dh1);
            ese_dh1 = 2.38*(1-exp(-Dh1/8.94))*log10(50/tPct);
            EDh1 = efs_dh1 + ese_dh1 ;
            
            value = (ED20 - EDh1)*log10(distance/Dh1)/log10(D20/Dh1);
            value = EDh1;
            
            return
        else
            E10D = calculateFieldStrengthForAntennaHeight(Frequency, land_sea,  fieldStrengths, distance,10, possibleAntennaHeights, tPct);
            E20D = calculateFieldStrengthForAntennaHeight(Frequency, land_sea,  fieldStrengths, distance,20, possibleAntennaHeights, tPct);
            Ep = E10D+(E20D - E10D)*log10(antennaHeight/10)/log10(20/10);
            E10 = interploateFieldStrengthForDistance(fieldStrengths, distance, 1);
            E20 = interploateFieldStrengthForDistance(fieldStrengths, distance, 2);
            C1020 = E10-E20;
            Ezero = E10 + 0.5*(C1020+C_h1neg10);
            Epp = Ezero+0.1*antennaHeight*(E10-Ezero);
            Fs = (distance - D20)/distance;
            value = Ep*(1-Fs)+Epp*Fs;
            return
        end
    end
end
for i = 1:length(possibleAntennaHeights)
    if possibleAntennaHeights(i) >= antennaHeight
        upper_antenna_index = i;
        break;
    end
end

if antennaHeight > 1200
    upper_antenna_index = 8;
end
lower_antenna_index = upper_antenna_index -1;

if (lower_antenna_index >= 1 && possibleAntennaHeights(lower_antenna_index) == antennaHeight) 
    value = interploateFieldStrengthForDistance(fieldStrengths, distance, lower_antenna_index );
elseif (possibleAntennaHeights(upper_antenna_index) == antennaHeight) 
    value = interploateFieldStrengthForDistance(fieldStrengths, distance, upper_antenna_index); 
else
    e_inf = interploateFieldStrengthForDistance(fieldStrengths, distance, lower_antenna_index );
    e_sub = interploateFieldStrengthForDistance(fieldStrengths, distance, upper_antenna_index );
    
    h_inf = possibleAntennaHeights(lower_antenna_index );
    h_sub = possibleAntennaHeights(upper_antenna_index );

    value = e_inf + (e_sub - e_inf) * (log10((antennaHeight / h_inf)) / log10((h_sub / h_inf))); 
end
end

