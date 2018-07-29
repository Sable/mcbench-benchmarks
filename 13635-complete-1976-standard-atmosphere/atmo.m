function [Z, Z_L, Z_U, T, P, rho, c, g, mu, nu, k, n, n_sum] = atmo(alt,division,units)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program:    1976 Standard Atmosphere Calculator[0-1000 km]
%   Author:     Brent Lewis(RocketLion@gmail.com)
%               University of Colorado-Boulder
%   History:    Original-1/10/2007
%               Revision-1/12/2007-Corrected for changes in Matlab versions
%               for backward compatability-Many thanks to Rich
%               Rieber(rrieber@gmail.com)
%   Input:      alt:        Final Geometric Altitude[km]
%               division:   Reporting points for output arrays[km]
%                           (.01 km & Divisible by .01 km)
%               units:      1-[Metric]
%                           2-{English}
%   Default:    Values used if no input
%               alt:        1000 km
%               division:   1 km
%               units:      Metric
%   Output:     Each value has a specific region that it is valid in with this model
%               and is only printed out in that region
%               Z:          Total Reporting Altitudes[0<=alt<=1000 km][km]{ft}
%               Z_L:        Lower Atmosphere Reporting Altitudes[0<=alt<=86 km][km]{ft}
%               Z_U:        Upper Atmosphere Reporting Altitudes[86<=alt<=1000 km][km]{ft}
%               T:          Temperature array[0<=alt<=1000 km][K]{R}
%               P:          Pressure array[0<=alt<=1000 km][Pa]{in_Hg}
%               rho:        Density array[0<=alt<=1000 km][kg/m^3]{lb/ft^3}
%               c:          Speed of sound array[0<=alt<=86 km][m/s]{ft/s}
%               g:          Gravity array[0<=alt<=1000 km][m/s^2]{ft/s^2}
%               mu:         Dynamic Viscosity array[0<=alt<=86 km][N*s/m^2]{lb/(ft*s)}
%               nu:         Kinematic Viscosity array[0<=alt<=86 km][m^2/s]{ft^2/s}
%               k:          Coefficient of Thermal Conductivity
%                           array[0<=alt<=86 km][W/(m*K)]{BTU/(ft*s*R)}
%               n:          Number Density of individual gases
%                           (N2 O O2 Ar He H)[86km<=alt<=1000km][1/m^3]{1/ft^3}
%               n_sum:      Number Density of total gases
%                           [86km<=alt<=1000km][1/m^3]{1/ft^3}
%   Acknowledgements:       1976 U.S. Standard Atmosphere
%                           Prof. Adam Norris-Numerical Analysis Class
%                           Steven S. Pietrobon USSA1976 Program
%   Notes:                  Program uses a 5-point Simpson's Rule in 10
%                           meter increments.  Results DO vary by less 1%
%                           compared to tabulated values and is probably
%                           caused by different integration techniques
%   Examples:               atmo() will compute the full atmosphere in 1 km
%                           increments and output in Metric Units
%                           atmo(10) will compute the atmosphere between 0
%                           and 10 km in 1 km increments and output in
%                           Metric Units
%                           atmo(20,.1,2) will compute the atmosphere
%                           between 0 and 20 km in 100 m increments and
%                           output in English Units
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 0
    alt = 1000;
    division = 1;
    units = 1;
elseif nargin == 1
    division = 1;
    units = 1;
elseif nargin == 2
    units = 1;
end

%   Error Reporting
if nargin > 3
    error('Too many inputs')
elseif mod(division,.01) ~= 0
    error('Divisions must be multiples of .01 km')
elseif units ~= 1 && units ~= 2
    error('Units Choice Invalid[1-Metric,2-English]')
elseif alt<0 || alt>1000
    error('Program only valid for 0<altitudes<1000 km')
end

%   Matrix Pre-allocation
if alt <= 86
    Z_L = (0:division:alt)';
    Z_U = [];
    n = [];
else
    Z_L = (0:division:86)';
    Z_U = (86:division:alt)';
    if mod(86,division) ~= 0
        Z_L = [Z_L; 86];
    end
    if mod(alt-86,division) ~= 0
        Z_U = [Z_U; alt];
    end
end
T_L = zeros(size(Z_L));
T_M_L = T_L;
T_U = zeros(size(Z_U));

%   Conversion Factor Used in 80<alt<86 km
Z_M = 80:.5:86;
M_M_0 = [1 .999996 .999989 .999971 .999941 .999909 ...
    .999870 .999829 .999786 .999741 .999694 .999641 .999579];

%   Constants
M_0 = 28.9644;
M_i = [28.0134; 15.9994; 31.9988; 39.948; 4.0026; 1.00797];
beta = 1.458e-6;
gamma = 1.4;
g_0 = 9.80665;
R = 8.31432e3;
r_E = 6.356766e3;
S = 110.4;
N_A = 6.022169e26;

%   Temperature
for i = 1 : length(Z_L)
    T_L(i,1) = atmo_temp(Z_L(i));
    T_M_L(i,1) = T_L(i,1);
    if Z_L(i) > 80 && Z_L(i) < 86
        T_L(i,1) = T_L(i)*interp1(Z_M,M_M_0,Z_L(i));
    end
end
for i = 1 : length(Z_U)
    T_U(i,1) = atmo_temp(Z_U(i));
end

%   Number Density
if alt > 86
    n = atmo_compo(alt,division);
    n_sum = sum(n,2);
else
    n = [];
    n_sum = [];
end

%   Pressure
P_L = atmo_p(Z_L);
P_U = atmo_p(Z_U,T_U,n_sum);

%   Density
rho_L = M_0*P_L./(R*T_M_L);
if ~isempty(P_U)
    rho_U = n*M_i/N_A;
else
    rho_U = [];
end

%   Speed of Sound
c = sqrt(gamma*R*T_M_L/M_0);
%   Dynamic Viscosity
mu = beta*T_L.^1.5./(T_L+S);
%   Kinematic Viscosity
nu = mu./rho_L;
%   Thermal Conductivity Coefficient
k = 2.64638e-3*T_L.^1.5./(T_L+245*10.^(-12./T_L));

%   Combine Models
T = [T_L(1:end-1*double(~isempty(T_U)));T_U];
P = [P_L(1:end-1*double(~isempty(T_U)));P_U];
rho = [rho_L(1:end-1*double(~isempty(T_U)));rho_U];
Z = [Z_L(1:end-1*double(~isempty(T_U)));Z_U];

%   Gravity
g = g_0*(r_E./(r_E+Z)).^2;

if units == 2
    unit_c = [3.048e-1 3.048e-1 3.048e-1 5/9 0.0001450377 1.6018463e1...
        3.048e-1 3.048e-1 1.488163944 9.290304e-2 6.226477504e-3...
        3.531466672e2 3.531466672e2];
    Z = Z/unit_c(1);
    Z_L = Z_L/unit_c(2);
    Z_U = Z_U/unit_c(3);
    T = T/unit_c(4);
    P = P/unit_c(5);
    rho = rho/unit_c(6);
    c = c/unit_c(7); 
    g = g/unit_c(8);
    mu = mu/unit_c(9);
    nu = nu/unit_c(10); 
    k = n/unit_c(11);
    n_sum = n_sum/unit_c(12);
end