function [T, Y]=FODuffing(parameters, orders, TSim, Y0)
%
% Numerical Solution of the Fractional-Order Duffing's System
%
%   D^q1 x(t) = y(t)
%   D^q2 y(t) = x(t) - alpha y(t) - x^3(t) + delta cos(omega t)
%
% function [T, Y] = FODuffing(parameters, orders, TSim, Y0)
%
% Input:    parameters - model parameters [alpha, delta, gamma]
%           orders - derivatives orders [q1, q2]
%           TSim - simulation time (0 - TSim) in sec
%           Y0 - initial conditions [Y0(1), Y0(2)]
%
% Output:   T - simulation time (0 : Tstep : TSim)
%           Y - solution of the system (x=Y(1), y=Y(2))
%
% Author:  (c) Ivo Petras (ivo.petras@tuke.sk), 2010.
%

% time step:
h=0.0005; 
% number of calculated mesh points:
n=round(TSim/h);
%orders of derivatives, respectively:
q1=orders(1); q2=orders(2); 
% constants of Duffing's system:
alpha=parameters(1); delta=parameters(2); omega=parameters(3);
% binomial coefficients calculation:
cp1=1; cp2=1; 
for j=1:n
    c1(j)=(1-(1+q1)/j)*cp1;
    c2(j)=(1-(1+q2)/j)*cp2;
    cp1=c1(j); cp2=c2(j); 
end
% initial conditions setting:
x(1)=Y0(1); y(1)=Y0(2); 
% calculation of phase portraits /numerical solution/:
for i=2:n
    x(i)=(y(i-1))*h^q1 - memo(x, c1, i);
    y(i)=(x(i)-alpha*y(i-1)-x(i)^3+delta*cos(omega*h*i))*h^q2 - memo(y, c2, i);
end
for j=1:n
    Y(j,1)=x(j);
    Y(j,2)=y(j);
end
T=h:h:TSim;
%