function OUT=rossler(t,X)
%ROSSLER  Rossler equation 
%          (a third-order continuous autonomous system)
%
%                     dx = -y - z
%                     dy = x + a*y
%                     dz = b + z*(x-c)
%
%          In this demo, a = 0.15, b = 0.20, c = 10.0
%          Initial conditions: x(0) = 1, y(0) = 1, z(0) = 1
%          Reference values: LE1 = 0.09, LE2 = 0.00, LE3 = -9.77, LD = 2.01
%
%          The reference values are from the following reference:
%
%          [1] A. Wolf, J. B. Swift, H. L. Swinney and J. A. Vastano,
%              "Determining Lyapunov Exponents from a Time Series,"
%              Physica D, Vol. 16, pp. 285-317, 1985.

%          by Steve Wai Kam SIU, July 1, 1998.

%Parmaters:
a = 0.15;
b = 0.20;
c = 10.0;

%Rearrange input data in desired format
%Note: the input data is a column vector
x=X(1); y=X(2); z=X(3);
Q =[X(4), X(7), X(10);
    X(5), X(8), X(11);
    X(6), X(9), X(12)];
 
%Rossler equation
dx = -y - z;
dy = x + a*y;
dz = b + z*(x-c);

DX=[dx; dy; dz]; %Output data

%Linearized system
J=[0, -1, -1;
    1,  a,  0;
    z,  0, -c];

%Variational equation
F=J*Q;

%Output data must be a column vector
OUT=[DX(:); F(:)];

