%%% ROOM PARAMETERS %%%
lx    =  5.7;                   % x-dimension of the room (meters)
ly    =  7.0;                   % y-dimension of the room (meters)
lz    =  4.8;                   % z-dimension of the room (meters)
S     =  2*(lx*ly+lx*lz+ly*lz); % Area of the room 
V     =  lx*ly*lz;              % Volume of the room
c     =  344;                   % speed of sound in air
rho   =  1.204;                 % density of sound in air
bta   =  (rho*c)/(6e2*1820);    % Specific wall admittance(dense concrete).

%%% GF as function of Frequency PARAMETERS %%%
fd    =  [5:0.1:80];            % frequency range
kd    =  2*pi.*fd/c;            % wavenumber
r0    =  [0;0;0];               % source position <<
r1    =  [0.1;0.1;0.1];         % 1 receiver position <<
r2    =  [lx;ly;lz];            % 2 receiver position <<

%%% GF as function of Distance PARAMETERS %%%
f01   =  48;                    % 1 fixed frequency <<
f02   =  45;                    % 2 fixed frequency <<
N     =  200;                   % number of points
d     =  [1:N+1];               % lenght distance