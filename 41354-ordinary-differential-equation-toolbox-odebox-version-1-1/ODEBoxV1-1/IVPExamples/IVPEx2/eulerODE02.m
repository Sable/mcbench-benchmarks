function dy = eulerODE02(x,y)
%
% Euler Differential Equation:
%
% 2 * x^2 * y'' - x * y' - 2 * y = 0
%
% With the initial conditions,
% y(1) = 5
% y'(1) = 0
% it has the solution:
%
% y = x^2 + 4/sqrt(x)
%
% Adams, Calculus of Several Variables, pp. 394-395
%
dy = zeros(2,1) ;
dy(1) = y(2) ;
dy(2) = (1/(2*x^2)) * ( x*y(2) + 2*y(1) ) ;
%
% END
%