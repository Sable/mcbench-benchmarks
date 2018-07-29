function redoxsteady
% Steady state redox zones
%    using MATLAB ode                   
%
%   $Ekkehard Holzbecher  $Date: 2006/03/31 $
%--------------------------------------------------------------------------
L = 100;                        % length [m]
v = 1;                          % velocity [m/s]
D = 0.2;                        % diffusivity [m*m/s]
lambda = 0.01;                  % organic carbon degradation parameter [1/m]  
k1 = [0.1; 1; 0.9];             % 1. Michaelis-Menten parameter
k2 = [0.035; 1; 1];             % 2. Michaelis-Menten parameter [kg/m*m*m]
k3 = [3.5e-3; 1];               % inhibition coefficient [kg/m*m*m]
corg = 1;                       % organic carbon concentration at interface 
cin = [4; 3; 0.001];            % interface concentrations [kg/m*m*m]
N = 100;                        % number of nodes  

%----------------------execution-------------------------------------------

x = linspace(0,L,N);
solinit = bvpinit (x,[cin; zeros(3,1)]);
sol = bvp4c(@redox,@bcs,solinit,odeset,D,v,lambda,k1,k2,k3,corg,cin);

%---------------------- graphical output ----------------------------------

plot (x,corg*exp(-lambda*x),sol.x,sol.y(1:3,:));
legend ('C_{org}','O_2','NO_2','Mn'); grid;

%----------------------functions------------------------------
function dydx = redox(x,y,D,v,lambda,k1,k2,k3,corg,cin)

c0 = corg*exp(-lambda*x);
monod = k1.*(y(1:3)>0).*y(1:3)./(k2+y(1:3));  
monod(3) = k1(3); 
inhib = k3./(k3+y(1:2));
dydx = zeros (6,1);
dydx(1) =  y(4);
dydx(4) =  (v*y(4)+c0*monod(1))/D;
dydx(2) =  y(5);
dydx(5) =  (v*y(5)+c0*monod(2)*inhib(1))/D;
dydx(3) =  y(6);
dydx(6) =  (v*y(6)-c0*monod(3)*inhib(1)*inhib(2))/D;

function res = bcs (ya,yb,D,v,lambda,k1,k2,k3,corg,cin)
res = [ya(1:3)-cin; yb(4:6)-zeros(3,1)];      

