function Temp = atmo_temp(alt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program:    Atmospheric Temperature Calculation
%   Author:     Brent Lewis(RocketLion@gmail.com)
%               University of Colorado-Boulder
%   History:    Original-1/09/2007
%   Input:      alt:    Geometric Altitude of desired altitude[scalar][km] 
%   Output:     Temp:   Temperature at desired altitude using values from 
%                       1976 Standard Atmosphere[K]
%   Note:       Only Valid Between 0 km and 1000 km
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Constants
r_E = 6.356766e3;
epsilon = 1e5*eps;

%   Defined temperatures at each layer
T = [288.15 216.65 216.65 228.65 270.65 270.65 ...
    214.65 186.95 186.8673 240 360 1000];
L = [-6.5 0 1 2.8 0 -2.8 -2 0 0 12 0];

%   Geopotential/Geometric Altitudes used for Geometric Altitudes < 86 km
H = [0 11 20 32 47 51 71];
Z = r_E*H./(r_E-H);
%   Geometric Altitudes used for Altitudes >86 km
Z(8:12) = [86 91 110 120 1000];

if alt < Z(1) || alt > (Z(12)+epsilon)
    error('Altitude must be 0-1000 km')
end

%   Temperature Calculation with Molecular Temperature below 86 km and
%   Kinetic Temperature above
if alt >= Z(1) && alt <= Z(8)
    Temp = interp1(Z,T,alt);
elseif alt > Z(8) && alt <= Z(9)
    Temp = T(9);
elseif alt > Z(9) && alt <= Z(10)
    a = 19.9429;
    A = -76.3232;
    T_c = 263.1905;
    Temp = T_c+A*sqrt(1-((alt-Z(9))/a)^2);
elseif  alt > Z(10) && alt <= Z(11)
    Temp = interp1(Z,T,alt);
elseif alt > Z(11)
    lambda = L(10)/(T(12)-T(11));
    xi = (alt-Z(11))*(r_E+Z(11))/(r_E+alt);
    Temp = T(12)-(T(12)-T(11))*exp(-lambda*xi);
end