function OUT=stewart(t,X)
%STEWART    Stewart-McCumber model (a second-order non-autonomous system)
%
%                dx/dt = y
%                dy/dt = 1/a[-y - sin(x) + b + c*sin(d*t)]
%
%           In this demo, a = 25, b = 1.8, c = 10.19804, d = 0.2
%           The initial conditions are: x(0) = y(0) = z(0) = 0  (where z = t)
%
%           The reference values are: LE1 = 0.0286, LE2 = 0.00, LE3 = -0.0687, LD = 2.416
%
%           The reference values are from the following reference
%
%           [1] H. Uhlmann, G. Mader and L. Finger, "Identification of the Irregular 
%               Behaviour in Nonlinear Electrical Circuits by the Time Series Method," 
%               Proc. of NDES'93, pp. 163-180, 1993.

%          by Steve W. K. SIU, July 5, 1998.

%Parameters
a=25;
b=1.8;
c=10.19804;
d=0.2;

%Rearrange input data
x=X(1); y=X(2); z=X(3);
Q =[X(4), X(7), X(10);
    X(5), X(8), X(11);
    X(6), X(9), X(12)];


%Stewart-McCumber model
dx=y;
dy=(-y-sin(x)+b+c*sin(d*z))/a;
dz=1;

DX1=[dx; dy; dz];      %Output data

%Linearize system (Jacobian)
J=[         0,     1,               0;
    -cos(x)/a,   -1/a,  b*c*cos(c*z)/a;
            0,     0,              0];

%Variational equation
F=J*Q;

%Output must be a column vector
OUT=[DX1; F(:)];

