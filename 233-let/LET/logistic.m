function X2=logistic(X1)

%LOGISTIC  Logistic map (a 1st-order discrete system):
%
%                 x(k+1) = a*x(k) - b*x(k)^2
%
%          In this demo, the parameters are: a = b = 4.
%          Initial condition: x(0) = 0.1
%          True Lyapunov exponent value: LE1 = ln(2) = 0.693
%          Lyapunov Dimension (LD) is not defined for 1st-order system.
%          (LD = 0 will be shown for an undefined LD)

%          by Steve Wai Kam SIU, Jun. 28, 1998.

%Parameters
a=4;
b=4;

%Logistic map
x1=X1(1);
x2=a*x1-b*(x1^2);

%Linearized equation
J=a-2*b*x1;

%Variational equation
Q=X1(2);
F=J*Q;

%Put output data in a column vector
X2=[x2;F];
