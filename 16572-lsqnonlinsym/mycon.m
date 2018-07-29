function [c,ceq] = mycon(x,a2)
c = a2/x(1) - x(2);
ceq = x(1)-x(2);