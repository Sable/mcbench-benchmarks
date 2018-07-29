function StreeterPhelps
% Streeter Phelps - simple stream purification modelling 
%    using MATLAB ode                   
%
%   $Ekkehard Holzbecher  $Date: 2006/04/10 $
%--------------------------------------------------------------------------
T = 25;                % maximum time [T]
k1 = 0.3;              % deoxygenation rate coefficient [1/T]
k2 = 0.4;              % reaeration rate coefficient [1/T]
DOsat = 11;            % DO saturation [M/L^3] 
BODin = 7.33;          % initial BOD [M/L^3]
DOin = 8.5;            % initial DO concentrations [M/L^3]
fBOD = 1;              % natural BOD inflow [M/L^3/T]          
N = 60;                % discretization of time

%----------------------execution-------------------------------------------
% BOD = y(1), DO = y(2)
options = odeset('AbsTol',1e-20);
[t,y] = ode15s(@SP,[0 T],[BODin; DOin],options,k1,k2,DOsat,fBOD);

%---------------------- graphical output ----------------------------------

plot (t,y);
legend ('BOD','DO');
xlabel ('traveltime'); ylabel ('concentration');
grid;

%---------------------- function ------------------------------------------

function dydt = SP(t,y,k1,k2,DOsat,fBOD)
dydt = zeros(2,1);
k3 = k1*(1 + 0.5*sin(t*(pi+pi)));
dydt(1) = fBOD-k3*y(1);
dydt(2) = k2*(DOsat-y(2))-k3*y(1);
