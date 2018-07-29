% Author: Housam Binous

% Forced Duffing Oscillator

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

function xdot=duffing(t,x)

global gamma omega epsilon GAM OMEG

xdot(1)=-gamma*x(1)+omega^2*x(2)-epsilon*x(2)^3+GAM*cos(OMEG*t);
xdot(2)=x(1);

xdot=xdot';

end
