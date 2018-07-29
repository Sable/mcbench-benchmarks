function dy = eulerODE01(x,y)
%
% Differential Equation:
%
% y'' + 6 * y' + 9 * y = 0
%
% With the initial conditions,
% y(1) = 5
% y'(1) = -1
% it has the solution:
%
% y = x^2 + 4/sqrt(x)
%
% Adams, Calculus of Several Variables, pp. 394-395
%
dy = zeros(2,1) ;
dy(1) = y(2) ;
dy(2) = -( 6*y(2) + 9*y(1) ) ;
%
% END
%