function [T, Y]=FOvanDerPol(parameters, orders, TSim, Y0)
%
% Numerical Solution of the Fractional-Order Van der Pol's System
%
%   D^q1 x(t) = y(t)
%   D^q2 y(t) = -x(t) - eps(x^2(t)-1)y(t))
%
% function [T, Y] = FOvanDerPol(parameters, orders, TSim, Y0)
%
% Input:    parameters - model parameter [eps]
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
% constants of van Der Pol's system:
eps=parameters(1); 
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
    y(i)=(z(i-1))*h^q1 - memo(y, c1, i);
    z(i)=(-y(i)-eps*(y(i).^2-1).*z(i-1))*h^q2 - memo(z, c2, i);
end
for j=1:n
    Y(j,1)=x(j);
    Y(j,2)=y(j);
end
T=h:h:TSim;
%