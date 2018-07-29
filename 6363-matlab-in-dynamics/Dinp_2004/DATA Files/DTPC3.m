 % Data File DTPC3
 % Dynamics of a particle, moving
 % on a horizontal plane under action 
 % of a body, bound up to the particle
 % by a non elastic thread. The body can
 % move in vertical direction.
   m    =  'm';  % mass of the particle
          % Projections of forces on axis [r] and [f]
   Fr   = '-G*(1+rtt/9.81)-9.81*mu*m*rt/sqrt(rt^2+r^2*ft^2)';
   Ff   = '-9.81*mu*m*r*ft/sqrt(rt^2+r^2*ft^2)';
   r0   = 1;     % Initial radius
   f0   = 0;     % Initial polar angle
   v0   = 10;    % Initial velocity
   alfa = pi/2;  % angle between v0 and polar axis
   Tend = 5;     % upper bound of integration
   eps  = 1e-10; % desirable accuracy
   np   = 3;     % number of parameters
   P{1} = 'm';   % mass of the particle
   P{2} = 'G';   % weight of the body
   P{3} = 'mu';  % coefficient of dry friction