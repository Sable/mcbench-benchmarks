function X2=henon(X1)
%HENON   Henon map (a 2nd-order discrete system)
%
%             x(n+1) = 1 - a*x(n)^2 + y(n)
%             y(n+1) = b*x(n)
%
%        In this demo, a = 1.4, b = 0.3, 
%        Initial conditions: x(0) = 0, y(0) = 0
%        Reference values are:  LE1 = 0.418, LE2 = -1.621, LD = 1.26
%
%        The reference values are from the following references:
%
%        [1] A. Wolf, J. B. Swift, H. L. Swinney and J. A. Vastano,
%           "Determining Lyapunov Exponents from a Time Series,"
%            Physica D, Vol. 16, pp. 285-317, 1985.
%
%        [2] Keith Briggs, "An Improved Method for Estimating Liapunov
%            Exponents of Chaotic Time Series," Phys. Lett. A, Vol. 151,
%            pp. 27-32, Nov. 1990.

%        by Steve Wai Kam SIU, Jun. 29, 1998.

%Parameters
a=1.4;
b=0.3;

%Rearrange input data in desired format
%Note: the input data is a column vector
x=X1(1);
y=X1(2);
Q=[X1(3),X1(5);
   X1(4),X1(6)];

%Henon map
X=1-a*(x^2)+y;
Y=b*x;

%Linearized system
J=[-2*a*x, 1;
        b, 0];

%Variational equation
F=J*Q;

%Output data
X2=[X; Y; F(:)];
