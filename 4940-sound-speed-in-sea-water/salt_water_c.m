function sspeed = salt_water_c(temp_C, depth, sal);
%   Calculate sound speed [m/s] in sea water as function of temperature
%   [degree C], depth [meter], and salinity in parts per thousand [ppt] 
%   using nine-term Mackenzie equation that yelds standard error of sound 
%   speed estimate =0.070m/s.  For near surface depth, typical values of salinity 
%   are in the range from 30 to 40 ppt (at t=0-30C).  Examples of calculations: 
%   1511.2= salt_water_c(17, 1, 33.6); 
%   1482.3 = salt_water_c(3.51, 1200, 33.51);
%
% References:
% Mackenzie, K.V., "Nine-term Equation for Sound Speed in the Oceans", 
% JASA, vol. 70, No. 3, Sept. 1981, pp. 807 - 812
% Mackenzie, K.V., "Discussion of Sea Water Sound-speed Determinations",
% JASA, vol. 70, No. 3, Sept. 1981  pp. 801 - 806

%_____________________________________________________
% 	Sergei Koptenko, Resonant Medical Inc., Toronto  |
%	sergei.koptenko@resonantmedical.com              |
%______________April/30/2004_________________________|


sspeed  = 1448.96 + 4.591 .* temp_C - 5.304 *10^-2 .* temp_C .^2 + 2.374*10^-4 .* temp_C .^3 ...
    +1.340 .* (sal-35) + 1.630 *10^-2 .* depth + 1.675 *10^-7 .* depth .^2 ...
    -1.025*10^-2 .* temp_C .* (sal-35) - 7.139 *10^-13 .* temp_C .*depth .^3; 
    
    return
