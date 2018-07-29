% Data File DTXY2
% Motion of a particle on a horizontal
% plane under action of an elastic and
% a resistance force
 m    =  'm';   % mass of the particle
 Fx   = '-c*x-k*xt'; % Projections of forces
 Fy   = '-c*y-k*yt'; % on axis x and y
 x0   = 'x0';   % Initial
 y0   = 'y0';   % coordinates
 v0   = 'v0';   % Initial velocity
 alfa = 'alfa'; % angle betweån v0 and axis x
 Tend = 10;     % upper bound of integration
 eps  = 1e-10;  % desirable accuracy
 np   = 3;      % number of parameters
 P{1} = 'm';    % mass of the particle
 P{2} = 'c';    % spring stiffness
 P{3} = 'k';    % coefficient of damping