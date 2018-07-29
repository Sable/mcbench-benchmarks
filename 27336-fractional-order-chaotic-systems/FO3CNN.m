function [T, Y]=FO3CNN(parameters, orders, TSim, Y0)
%
% Numerical Solution of the Fractional-Order 3-Cells CNN 
%
%   D^q1 x1(t) = -x1(t) + p1 f(x1(t)) - s f(x2(t)) - s f(x3(t))
%   D^q2 x2(t) = -x2(t) - s f(x1(t)) + p2 f(x2(t)) - r f(x3(t))
%   D^q3 x3(t) = -x3(t) - s f(x1(t)) + r f(x2(t)) + p3 f(x3(t))
%
% function [T, Y] = FO3CNN(parameters, orders, TSim, Y0)
%
% Input:    parameters - model parameters [p1, p2, p3, r, s]
%           orders - derivatives orders [q1, q2, q3]
%           TSim - simulation time (0 - TSim) in sec
%           Y0 - initial conditions [Y0(1), Y0(2), Y0(3)]
%
% Output:   T - simulation time (0 : Tstep : TSim)
%           Y - solution of the system (x1=Y(1), x2=Y(2), x3=Y(3))
%
% Author:  (c) Ivo Petras (ivo.petras@tuke.sk), 2010.
%

% time step:
h=0.005; 
% number of calculated mesh points:
n=round(TSim/h);
%orders of derivatives, respectively:
q1=orders(1); q2=orders(2); q3=orders(3);
% constants of 3-cells CNN system:
p1=parameters(1); p2=parameters(2); p3=parameters(3); 
r=parameters(4); s=parameters(5); 
% binomial coefficients calculation:
cp1=1; cp2=1; cp3=1;
for j=1:n
    c1(j)=(1-(1+q1)/j)*cp1;
    c2(j)=(1-(1+q2)/j)*cp2;
    c3(j)=(1-(1+q3)/j)*cp3;
    cp1=c1(j); cp2=c2(j); cp3=c3(j);
end
% initial conditions setting:
x(1)=Y0(1); y(1)=Y0(2); z(1)=Y0(3);
% calculation of phase portraits /numerical solution/:
for i=2:n
    x(i)=(-x(i-1)+p1*f_x_CNN(x(i-1))-s*f_x_CNN(y(i-1))-s*f_x_CNN(z(i-1)))*h^q1 - memo(x, c1, i);
    y(i)=(-y(i-1)-s*f_x_CNN(x(i))+p2*f_x_CNN(y(i-1))-r*f_x_CNN(z(i-1)))*h^q2 - memo(y, c2, i);
    z(i)=(-z(i-1)-s*f_x_CNN(x(i))+r*f_x_CNN(y(i))+p3*f_x_CNN(z(i-1)))*h^q3 - memo(z, c3, i);
end
for j=1:n
    Y(j,1)=x(j);
    Y(j,2)=y(j);
    Y(j,3)=z(j);
end
T=h:h:TSim;
%