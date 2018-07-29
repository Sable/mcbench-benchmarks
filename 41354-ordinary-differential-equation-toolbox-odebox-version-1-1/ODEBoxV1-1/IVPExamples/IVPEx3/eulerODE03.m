function dy = eulerODE03(x,y)
%
% Differential Equation:
%
% y''' + 3 * y'' + 3 * y' + y = 30 exp(-x);
%
% With the initial conditions,
% y(0) = 3
% y'(0) = -3
% y'''(0) = -47
%
% it has the solution:
%
% y = (3 - 25 x^2) e^{-x} + 5 x^3 e^{-x}
%
%Erwin Kreyszig, Advanced Engineering Mathematics pp.139-140
%
dy = zeros(2,1) ;
dy(1) = y(2) ;
dy(2) = y(3);
dy(3) = 30 * exp(-x) - (3 * y(3) + 3 * y(2) + y(1)) ;