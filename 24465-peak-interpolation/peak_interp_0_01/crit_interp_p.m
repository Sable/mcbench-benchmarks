function [x_max y_max A]=crit_interp_p(y,x)
%[x_max y_max A]=crit_interp_p(y,x)
%fits a parabola to three points: y=[y(x(1)) y(x(2)) y(x(3))]. 
%Returns the position (x_max) and value (y_max) of the
%interpolated critical point (peak or trough). 
%If x is omitted, it is assumed to be [-1 0 1]
%y=A(1)*x.^2+A(2)*x+A(3)

%    Copyright Travis Wiens 2009 travis.mlfx@nutaksas.com

if nargin<2
    x=[-1 0 1];
end

d = (x(1) - x(2)) * (x(1) - x(3)) * (x(2) - x(3));%denominator
a = (x(3) * (y(2) - y(1)) + x(2) * (y(1) - y(3)) + x(1) * (y(3) - y(2))) / d;
b = (x(3)*x(3) * (y(1) - y(2)) + x(2)*x(2) * (y(3) - y(1)) + x(1)*x(1) * (y(2) - y(3))) / d;
c = (x(2) * x(3) * (x(2) - x(3)) * y(1) + x(3) * x(1) * (x(3) - x(1)) * y(2) + x(1) * x(2) * (x(1) - x(2)) * y(3)) / d;

x_max=-b/(2*a);%critical point position

if nargout>1
    y_max=c-b^2/(4*a);%critical point value
end

if nargout>2
    A=[a b c];%parabola coefficients
end
