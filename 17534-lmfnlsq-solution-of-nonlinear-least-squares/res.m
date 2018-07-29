function dq = res(p)
%%%%%%%%%%%%%%%%%%%%%

global x y p0

p = p.*p0;
dq = p(1)*(1-exp(-p(2)*x)) - y;
