% function [t, p, rho, a] = atmosphere(height, unit)
% Richard Rieber
% rrieber@gmail.com
% Updated 3/17/2006
%
% Function to determine temperature, pressure, density, and speed of sound
% as a function of height.  Function based on US Standard Atmosphere of
% 1976.  All calculations performed in metric units, but converted to
% english if the user chooses.  Assuming constant gravitational
% acceleration.
%
% Input  o height (feet or meters), can be a 1-dimensional vector
%        o unit - optional; default is metric;
%                 boolean, True for english units, False for metric
% Output o t - Temperature (K (default) or R)
%        o p - Pressure (pa (default) or psi)
%        o rho - Density (kg/m^3 (default) or lbm/ft^3)
%        o a - speed of sound (m/s (default) or ft/s)

function [t, p, rho, a] = atmosphere(height,unit)

if nargin < 1
    error('Error:  Not enough inputs: see help atmosphere.m')
elseif nargin > 2
    error('Error:  Too few inputs: see help atmosphere.m')
elseif nargin == 2
    unit = logical(unit);
elseif nargin == 1
   unit = 0;
end

for j = 1:length(height)
	if height(j) < 0
        error('Height should be greater than 0')
	end
	
	m2ft = 3.2808;
	K2R = 1.8;
	pa2psi = 1.450377377302092e-004;
	kg2lbm = 2.20462262184878;
	
	if unit
        height(j) = height(j)/m2ft;
	end
	
	g = 9.81;       %Acceleration of gravity (m/s/s)
	gamma = 1.4;    %Ratio of specific heats
	R = 287;        %Gas constant for air (J/kg-K)
	
	%Altitudes (m)
	Start = 0;
	H1 = 11000;
	H2 = 20000;
	H3 = 32000;
	H4 = 47000;
	H5 = 51000;
	H6 = 71000;
	H7 = 84852;
	
	%Lapse Rates (K/m)
	L1 = -0.0065;
	L2 = 0;
	L3 = .001;
	L4 = .0028;
	L5 = 0;
	L6 = -.0028;
	L7 = -.002;
	
	%Initial Values
	T0 = 288.16;     %(k)
	P0 = 1.01325e5;  %(pa)
	Rho0 = 1.225;    %(kg/m^3)
	
	if height(j) <= H1
        [TNew, PNew, RhoNew] = Gradient(Start, height(j), T0, P0, Rho0, L1);    
        
	elseif height(j) > H1 & height(j) <= H2
        [TNew, PNew, RhoNew] = Gradient(Start, H1, T0, P0, Rho0, L1);
        [TNew, PNew, RhoNew] = IsoThermal(H1, height(j), TNew, PNew, RhoNew);
        
	elseif height(j) > H2 & height(j) <= H3
        [TNew, PNew, RhoNew] = Gradient(Start, H1, T0, P0, Rho0, L1);
        [TNew, PNew, RhoNew] = IsoThermal(H1, H2, TNew, PNew, RhoNew);
        [TNew, PNew, RhoNew] = Gradient(H2, height(j), TNew, PNew, RhoNew, L3);
        
	elseif height(j) > H3 & height(j) <= H4
        [TNew, PNew, RhoNew] = Gradient(Start, H1, T0, P0, Rho0, L1);
        [TNew, PNew, RhoNew] = IsoThermal(H1, H2, TNew, PNew, RhoNew);
        [TNew, PNew, RhoNew] = Gradient(H2, H3, TNew, PNew, RhoNew, L3);    
        [TNew, PNew, RhoNew] = Gradient(H3, height(j), TNew, PNew, RhoNew, L4);
        
	elseif height(j) > H4 & height(j) <= H5
        [TNew, PNew, RhoNew] = Gradient(Start, H1, T0, P0, Rho0, L1);
        [TNew, PNew, RhoNew] = IsoThermal(H1, H2, TNew, PNew, RhoNew);
        [TNew, PNew, RhoNew] = Gradient(H2, H3, TNew, PNew, RhoNew, L3);    
        [TNew, PNew, RhoNew] = Gradient(H3, H4, TNew, PNew, RhoNew, L4);
        [TNew, PNew, RhoNew] = IsoThermal(H4, height(j), TNew, PNew, RhoNew);
        
	elseif height(j) > H5 & height(j) <= H6
        [TNew, PNew, RhoNew] = Gradient(Start, H1, T0, P0, Rho0, L1);
        [TNew, PNew, RhoNew] = IsoThermal(H1, H2, TNew, PNew, RhoNew);
        [TNew, PNew, RhoNew] = Gradient(H2, H3, TNew, PNew, RhoNew, L3);    
        [TNew, PNew, RhoNew] = Gradient(H3, H4, TNew, PNew, RhoNew, L4);
        [TNew, PNew, RhoNew] = IsoThermal(H4, H5, TNew, PNew, RhoNew);    
        [TNew, PNew, RhoNew] = Gradient(H5, height(j), TNew, PNew, RhoNew, L6);
	
	elseif height(j) > H6 & height(j) <= H7
        [TNew, PNew, RhoNew] = Gradient(Start, H1, T0, P0, Rho0, L1);
        [TNew, PNew, RhoNew] = IsoThermal(H1, H2, TNew, PNew, RhoNew);
        [TNew, PNew, RhoNew] = Gradient(H2, H3, TNew, PNew, RhoNew, L3);    
        [TNew, PNew, RhoNew] = Gradient(H3, H4, TNew, PNew, RhoNew, L4);
        [TNew, PNew, RhoNew] = IsoThermal(H4, H5, TNew, PNew, RhoNew);    
        [TNew, PNew, RhoNew] = Gradient(H5, H6, TNew, PNew, RhoNew, L6);
        [TNew, PNew, RhoNew] = Gradient(H6, height(j), TNew, PNew, RhoNew, L7);  
	else
        warning('Height is out of range')
	end
	
	t(j) = TNew;
	p(j) = PNew;
	rho(j) = RhoNew;
	a(j) = (R*gamma*t(j))^.5;
	
	if unit
        t(j) = t(j)*K2R;
        p(j) = p(j)*pa2psi;
        rho(j) = rho(j)*kg2lbm/m2ft^3;
        a(j) = a(j)*m2ft;
	end
end

function [TNew, PNew, RhoNew] = Gradient(Z0, Z1, T0, P0, Rho0, Lapse)
g = 9.81;       %Acceleration of gravity (m/s/s)
gamma = 1.4;    %Ratio of specific heats
R = 287;        %Gas constant for air (J/kg-K)

TNew = T0 + Lapse*(Z1 - Z0);
PNew = P0*(TNew/T0)^(-g/(Lapse*R));    
% RhoNew = Rho0*(TNew/T0)^(-(g/(Lapse*R))+1);
RhoNew = PNew/(R*TNew);

function [TNew, PNew, RhoNew] = IsoThermal(Z0, Z1, T0, P0, Rho0)
g = 9.81;       %Acceleration of gravity (m/s/s)
gamma = 1.4;    %Ratio of specific heats
R = 287;        %Gas constant for air (J/kg-K)

TNew = T0;         
PNew = P0*exp(-(g/(R*TNew))*(Z1-Z0));        
% RhoNew = Rho0*exp(-(g/(R*TNew))*(Z1-Z0));
RhoNew = PNew/(R*TNew);