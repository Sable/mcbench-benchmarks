function boudreau_westrich
% Steady state sulfate profile in aquatic sediments
%    using MATLAB ode                   
%
%   $Ekkehard Holzbecher  $Date: 2006/04/03 $
%--------------------------------------------------------------------------
L = 1000;                       % length [m]
v = 1;                          % velocity [m/s]
D = 30000;                      % diffusivity [m*m/s]
k = 0.005;                      % 1. Michaelis-Menten parameter [m/s]
KS = 0.5;                       % 2. Michaelis-Menten parameter [kg/m*m*m]
f = 0.001;                      % mass ratio factor [1]
cin = [1000; 1];                % interface concentrations [kg/m*m*m]
N = 100;                        % number of nodes  

%----------------------execution-------------------------------------------

solinit = bvpinit (linspace(0,L,N),[cin; 0]);
sol = bvp4c(@bw,@bwbc,solinit,odeset,D,v,k,KS,f,cin);

%---------------------- graphical output ----------------------------------

plotyy (sol.x,sol.y(1,:),sol.x,sol.y(2,:));
legend ('Corg','SO_4'); grid;

%----------------------functions-------------------------------------------
function dydx = bw(x,y,D,v,k,KS,f,cin)

monod = k*y(2)/(KS+y(2));  
dydx = zeros (3,1);
dydx(1) =  -monod*y(1)/v;
dydx(2) =  y(3);
dydx(3) =  (v*y(3)+f*monod*y(1))/D;

function res = bwbc (ya,yb,D,v,k,KS,f,cin)
res = [ya(1:2)-cin; yb(3)];      

