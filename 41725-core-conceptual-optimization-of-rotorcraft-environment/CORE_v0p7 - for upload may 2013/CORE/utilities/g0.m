function g = g0(unit)
%  g0 Gravitational acceleration
%   g0 returns gravitational acceleration in m/s^2
%
%   g0(unit) where unit is a string 'SI' or 'US' returns gravitational
%   acceleration in m/s^2 or ft/s^2 respectively
%
%   Author:     Sky Sartorius
%               sky.sartorius(at)gmail.com

if nargin == 0 || strcmpi(unit,'SI')
    g = 9.80665;
elseif strcmpi((unit),'US')
    g = 32.174048556430442;
else
    error('error using g0. See help g0')
end