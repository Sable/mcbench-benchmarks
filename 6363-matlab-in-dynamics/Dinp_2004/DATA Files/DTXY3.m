% Data File DTXY3
% Motion of a particle on a horizontal
% plane under action of elastic and
% resistance forces and force of 
% dry friction
 m    =  'm';   % mass of the particle
        % Projections of forces on axis x and y
 Fx   = '-c*x-k*xt - mu*m*9.81*xt/sqrt(xt^2+yt^2)';
 Fy   = '-c*y-k*yt - mu*m*9.81*yt/sqrt(xt^2+yt^2)';
 x0   = '1';    % Initial
 y0   = '0';    % coordinates
 v0   = 'v0';   % Initial velocity
 alfa = 'alfa'; % angle between v0 and axis x
 Tend = 7;      % upper bound of integration
 eps  = 1e-10;  % desirable accuracy
 np   = 4;      % number of parameters
 P{1} = 'm';    % mass of the particle
 P{2} = 'c';    % spring stiffness
 P{3} = 'k';    % coefficient of resistance
 P{4} = 'mu';   % coefficient of dry friction