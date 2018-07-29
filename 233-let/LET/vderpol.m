function DX=vderpol(t,X)
%VDERPOL   Duffing-Van Der Pol equation
%          (a second-order non-autonomous system)
%
%          dx/dt = y
%          dy/dt = a*(1 - x^2)*y - x^3 + b*cos(c*t)
%
%        In this demo, a = 0.2, b = 5.8, c = 3
%        The initial conditions are: x(0) = y(0) = z(0) = 0
%
%        The reference values are: LE1 = 0.32, LE2=0.00, LE3 = -0.53, LD = 2.604
%
%        The reference values are from the following reference:
%        [1] H. Uhlmann, G. Mader and L. Finger, "Identification of the Irregular 
%            Behaviour in Nonlinear Electrical Circuits by the Time Series Method,"
%            Proc. of NDES'93, pp. 163-180, 1993.
%

%         by Steve Wai Kam SIU, July 1, 1998.

%Parametes
a=0.2; b=5.8; c=3;

%Rearrange input data
x=X(1); y=X(2); z=X(3);
Q=[X(4), X(7), X(10);
   X(5), X(8), X(11);
   X(6), X(9), X(12)];

%Duffing's Van Der Pol equation
dx=y;
dy=a*(1-x^2)*y-x^3+b*cos(c*z);
dz=1;

%Linearized system (Jacobian)
J = [          0,         1,           0;
    -2*a*x-3*x^2, a*(1-x^2), -c*sin(c*z);
               0,         0            0];

%Variational equation
F=J*Q;

%Output data
DX=[dx; dy; dz; F(:)];

