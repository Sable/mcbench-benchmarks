% function to implement the measurement model
function obs = f_h(x)
% Input:
% x  = [xc xcd zc zcd p1 p2 w].'

obs = zeros(2,1);

load avar % r1,r2, L, and T

% unpack
xc = x(1); zc = x(3); p1 = x(5); p2 = x(6);

% observation 1
obs(1,1) = L*(xc+r1*cos(p1))/(zc+r1*sin(p1));

% observation 2
obs(2,1) = L*(xc+r2*cos(p2))/(zc+r2*sin(p2));