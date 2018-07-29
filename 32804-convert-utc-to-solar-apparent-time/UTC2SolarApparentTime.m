function [SAT,SMT] = UTC2SolarApparentTime(UTC,Lon)

% Programmed by Darin C. Koblick (09/04/2011)

%External Function Call Sequence:
%>> [SAT,SMT] = UTC2SolarApparentTime('2000/03/20 15:00:00',-1.416667);
%>> [SAT,SMT] = UTC2SolarApparentTime('2000/09/23 15:00:00',-1.416667);

%Input Description:                                           Format:
% UTC (Coordinated Universal Time YYYY/MM/DD hh:mm:ss)       [N x 19] char
% Lon (Site Longitude in degrees -180:180 W(-) E(+))         [N x 1]

%Output Description:
% SAT (Solar Apparent Time YYYY/MM/DD hh:mm:ss)              [N x 19] char
% SMT (Solar Mean Time YYYY/MM/DD hh:mm:ss)                  [N x 19] char

%Source References:
%http://www.ips.gov.au/Category/Educational/The%20Sun%20and%20Solar%20Activity/General%20Info/EquationOfTime.pdf
%http://astro.ukho.gov.uk/nao/services/ais58.pdf

%File Dependencies:
%EquationOfTime.m           File ID: #32793         Darin C. Koblick

% Begin Code Sequence

DateStr = 'yyyy/mm/dd HH:MM:SS';
%Find the equation of time to the nearest minute
EoT = EquationOfTime(UTC);
%Find the date number of the input
dNum = datenum(UTC);
SMT_Days = dNum + (Lon.*4)./1440;
SAT_Days = SMT_Days + EoT./1440;
SMT = datestr(datevec(SMT_Days),DateStr);
SAT = datestr(datevec(SAT_Days),DateStr);
end