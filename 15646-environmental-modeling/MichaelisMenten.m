function MichaelisMenten
% Michaelis Menten kinetics - detailed and lumped model
%    using MATLAB ode                   
%
%   $Ekkehard Holzbecher  $Date: 2006/04/10 $
%--------------------------------------------------------------------------
T = 25;
k = [1 0.15 0.4];   % reaction rates
s0 = 1;             % initial substrate 
e0 = .2;            % initial enzyme
i0 = 0.1;           % initial intermediate
p0 = 0.3;           % initial product

%----------------------execution-------------------------------------------
% substrate = y(1), enzyme2 = y(2), intermediate = y(3), product = y(4)

options = odeset('AbsTol',1e-20);
[t,y] = ode15s(@detail,[0 T],[s0; e0; i0; p0],options,k);
[tt,z] = ode15s(@lumped,[0 T],s0,options,e0,i0,k);

%---------------------- graphical output ----------------------------------

plot(t,y(:,1:4));
hold on;
plot(tt,z(:,1),'--',tt,s0-z(:,1)+p0,'--');
legend ('substrate','enzyme','intermediate','product','lumped substrate','lumped product');
xlabel('time'); ylabel('concentration');
grid;

%---------------------- functions -----------------------------------------
function dydt = detail(t,y,k)
r1 = k(1)*y(1)*y(2);
r2 = k(3)*y(3);
r3 = k(2)*y(3);
dydt = zeros(4,1);
dydt(1) = -r1 + r2;
dydt(2) = -r1 + r2 + r3;
dydt(3) = r1 - r2 - r3;
dydt(4) = r3;

function dzdt = lumped(t,z,e0,i0,k)
dzdt(1) = -k(1)*k(2)*(e0+i0)*z/(k(2)+k(3)+k(1)*z);
