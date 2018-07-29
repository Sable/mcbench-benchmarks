% Author: Housam Binous

% Dynamic and control of a tank using the genetic algorithm toolbox

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

function xdot=tank(t,x)

% governing equation for the tank's dynamics

A=4;k=0.5;

xdot=1/A*(1-k*sqrt(x));

end
