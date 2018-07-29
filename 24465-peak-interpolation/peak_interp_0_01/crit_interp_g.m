function [x_max y_max A]=crit_interp_g(y,x);
%fits a gaussian to three points: y=[y(x(1)) y(x(2)) y(x(3))]. Returns the 
%position (x_max) and value (y_max) of the interpolated critical point 
%(peak or trough). Things go sideways (complex) if y is mixed sign and
%rounding errors can cause spurious complex results if y is negative.
%If x is omitted, it is assumed to be [-1 0 1].
%y=A(1)*exp(-A(2)*(x-A(3)).^2)

%    Copyright Travis Wiens 2009 travis.mlfx@nutaksas.com

if nargin<2
    x=[-1 0 1];
end

lny=log(y);

%lny=1/denom*(a*x^2+b*x+c)
a =(x(3) * (lny(2) - lny(1)) + x(2) * (lny(1) - lny(3)) + x(1) * (lny(3) - lny(2)));
b =(x(3)*x(3) * (lny(1) - lny(2)) + x(2)*x(2) * (lny(3) - lny(1)) + x(1)*x(1) * (lny(2) - lny(3)));
c =(x(2) * x(3) * (x(2) - x(3)) * lny(1) + x(3) * x(1) * (x(3) - x(1)) * lny(2) + x(1) * x(2) * (x(1) - x(2)) * lny(3));

%y=A*exp(-B*(x-C)^2);
C=-b/(2*a);
x_max=C;

if nargout>1
    denom = (x(1) - x(2)) * (x(1) - x(3)) * (x(2) - x(3));
    A=exp(c/denom-b*b/(4*a*denom));
    y_max=A;
    if nargout>2
        B=-a/denom;
        A=[A B C];
    end
end
