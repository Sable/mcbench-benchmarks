 % Data File DTPC1
 % Dynamics of a particle, moving
 % on a horizontal plane under action 
 % of an elastic and an resistance force.
   m    =  'm';          % mass of the particle
   Fr   = '-c*r - k*rt'; % projection of forces on axis [r]
   Ff   = '-k*r*ft';     % projection of forces on axis [f]
   r0   = 'r0';          % Initial
   f0   = 'f0';          % coordinates
   v0   = 'v0';          % Initial velocity
   alfa = 'alfa';        % angle between v0 and polar axis 
   Tend = 20;            % upper bound of integration
   eps  = 1e-10;         % desirable accuracy
   np   = 3;             % number of parameters
   P{1} = 'm';           % mass of the particle
   P{2} = 'c';           % spring stiffness
   P{3} = 'k';           % coefficient of resistance