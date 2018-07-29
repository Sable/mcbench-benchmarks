function P = atmo_p(alt, T, sum_n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program:    Atmospheric Pressure Calculation
%   Author:     Brent Lewis(RocketLion@gmail.com)
%               University of Colorado-Boulder
%   History:    Original-1/10/2007
%               Revision-1/12/2007-Corrected for changes in Matlab versions
%               for backward compatability-Many thanks to Rich
%               Rieber(rrieber@gmail.com)
%   Input:      alt:    Geometric altitude vector of desired pressure data[km]
%               T:      Temperature vector at given altitude points
%                       Required only for altitudes greater than 86 km[K]
%               sum_n:  Total number density of atmospheric gases[1/m^3]
%   Output:     P:      Pressure vector[Pa]
%   Note:       Must compute altitudes below 86 km and above 86 km on two
%               different runs to allow line up of altitudes and
%               temperatures
%   Examples:   atmo_p(0) = 101325 Pa
%               atmo_p(0:10) = Pressures between 0-10 km at 1 km increments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 1
    T = [];
    sum_n = [];
end

%   Constants
N_A = 6.022169e26;
g_0 = 9.80665;
M_0 = 28.9644;
R = 8.31432e3;
r_E = 6.356766e3;
%   Geopotential/Geometric Altitudes used for Geometric Altitudes < 86 km
H = [0 11 20 32 47 51 71 84.852];
Z = r_E*H./(r_E-H);
Z(8) = 86;

%   Defined temperatures/lapse rates/pressures/density at each layer
T_M_B = [288.15 216.65 216.65 228.65 270.65 270.65 214.65];
L = [-6.5 0 1 2.8 0 -2.8 -2]/1e3;
P_ref = [1.01325e5 2.2632e4 5.4748e3 8.6801e2 1.1090e2 6.6938e1 3.9564];

%   Preallocation of Memory
P = zeros(size(alt));

for i = 1 : length(alt)
    Z_i = alt(i);
    if isempty(sum_n)
        index = find(Z>=Z_i)-1+double(Z_i==0);
        index = index(1);
        Z_H = r_E*Z_i/(r_E+Z_i);
        if L(index) == 0
            P(i) = P_ref(index)*exp(-g_0*M_0*(Z_H-H(index))*1e3/(R*T_M_B(index)));
        else
            P(i) = P_ref(index)*(T_M_B(index)/...
                (T_M_B(index)+L(index)*(Z_H-H(index))*1e3))^...
                (g_0*M_0/(R*L(index)));
        end
    else
        P(i) = sum_n(i)*R*T(i)/N_A;
    end
end