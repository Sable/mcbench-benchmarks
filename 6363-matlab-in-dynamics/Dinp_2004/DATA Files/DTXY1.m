% Data File DTXY1
% Dynamics of a particle, thrown
% with initial velocity v0 under 
% angle "alfa' to the Horizon
 m    =  'm';    % mass of the particle
 Fx   = '-k*xt'; % Projections of forces 
 Fy   = '-k*yt - m*9.81'; % on axis x and y
 x0   = '0';     % Initial
 y0   = '0';     % coordinates
 v0   = 'v0';    % Initial velocity
 alfa = 'alfa';  % angle between v0 and horizon
 Tend = 20;      % upper bound of integration
 eps  = 1e-10;   % desirable accuracy
 np   = 2;       % number of parameters
 P{1} = 'm';     % mass of the particle
 P{2} = 'k';     % coefiicient of resistance