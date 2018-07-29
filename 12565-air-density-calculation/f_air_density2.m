function [ro] = air_density(t,hr,p)
% AIR_DENSITY calculates density of air
%  Usage :[ro] = air_density(t,hr,p)
%  Inputs:   t = ambient temperature (şC)
%           hr = relative humidity [%]
%            p = ambient pressure [Pa]  (1000 mb = 1e5 Pa)
%  Output:  ro = air density [kg/m3]

%
%  Refs:
% 1)'Equation for the Determination of the Density of Moist Air' P. Giacomo  Metrologia 18, 33-40 (1982)
% 2)'Equation for the Determination of the Density of Moist Air' R. S. Davis Metrologia 29, 67-70 (1992)
%
% ver 1.0   06/10/2006    Jose Luis Prego Borges (Sensor & System Group, Universitat Politecnica de Catalunya)
% ver 1.1   05-Feb-2007   Richard Signell (rsignell@usgs.gov)  Vectorized 

%-------------------------------------------------------------------------
T0 = 273.16;         % Triple point of water (aprox. 0şC)
 T = T0 + t;         % Ambient temperature in şKelvin

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% 1) Coefficients values

 R =  8.314510;           % Molar ideal gas constant   [J/(mol.şK)]
Mv = 18.015*10^-3;        % Molar mass of water vapour [kg/mol]
Ma = 28.9635*10^-3;       % Molar mass of dry air      [kg/mol]

 A =  1.2378847*10^-5;    % [şK^-2]
 B = -1.9121316*10^-2;    % [şK^-1]
 C = 33.93711047;         %
 D = -6.3431645*10^3;     % [şK]
 
a0 =  1.58123*10^-6;      % [şK/Pa]
a1 = -2.9331*10^-8;       % [1/Pa]
a2 =  1.1043*10^-10;      % [1/(şK.Pa)]
b0 =  5.707*10^-6;        % [şK/Pa]
b1 = -2.051*10^-8;        % [1/Pa]
c0 =  1.9898*10^-4;       % [şK/Pa]
c1 = -2.376*10^-6;        % [1/Pa]
 d =  1.83*10^-11;        % [şK^2/Pa^2]
 e = -0.765*10^-8;        % [şK^2/Pa^2]

%-------------------------------------------------------------------------
% 2) Calculation of the saturation vapour pressure at ambient temperature, in [Pa]
psv = exp(A.*(T.^2) + B.*T + C + D./T);   % [Pa]


%-------------------------------------------------------------------------
% 3) Calculation of the enhancement factor at ambient temperature and pressure
fpt = 1.00062 + (3.14*10^-8)*p + (5.6*10^-7)*(t.^2);


%-------------------------------------------------------------------------
% 4) Calculation of the mole fraction of water vapour
 xv = hr.*fpt.*psv.*(1./p)*(10^-2);


%-------------------------------------------------------------------------
% 5) Calculation of the compressibility factor of air
  Z = 1 - ((p./T).*(a0 + a1*t + a2*(t.^2) + (b0+b1*t).*xv + (c0+c1*t).*(xv.^2))) + ((p.^2/T.^2).*(d + e.*(xv.^2)));


%-------------------------------------------------------------------------
% 6) Final calculation of the air density in [kg/m^3]
 ro = (p.*Ma./(Z.*R.*T)).*(1 - xv.*(1-Mv./Ma));


