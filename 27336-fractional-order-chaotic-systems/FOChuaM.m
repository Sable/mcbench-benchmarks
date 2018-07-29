function [T, Y]=FOChuaM(parameters, orders, TSim, Y0)
%
% Numerical Solution of the Fractional-Order Chua's System
% with piecewise linear nonlinearity defined by a memristor.
%
%   D^q1 x(t) = alpha(y(t) - x(t) + epsilon x(t) - W(w)x(t)) 
%   D^q2 y(t) = x(t) - y(t) + z(t)
%   D^q3 z(t) = -beta y(t) - gamma z(t)
%   D^q4 w(t) = x(t)
%   where  W(x) is defined as W_w(a, b, w);
%
% function [T, Y] = FOChuaM(parameters, orders, TSim, Y0)
%
% Input:    parameters - model parameters [alpha, beta, gamma, epsilon, a, b]
%           orders - derivatives orders [q1, q2, q3, q4]
%           TSim - simulation time (0 - TSim) in sec
%           Y0 - initial conditions [Y0(1), Y0(2), Y0(3), Y0(4)]
%
% Output:   T - simulation time (0 : Tstep : TSim)
%           Y - solution of the system (x=Y(1), y=Y(2), z=Y(3), w=Y(4))
%
% Author:  (c) Ivo Petras (ivo.petras@tuke.sk), 2010.
%

% time step:
h=0.005; 
% number of calculated mesh points:
n=round(TSim/h);
%orders of derivatives, respectively:
q1=orders(1); q2=orders(2); q3=orders(3); q4=orders(4);
% constants of Chua's system:
alpha=parameters(1); beta=parameters(2); gamma=parameters(3);
epsilon=parameters(4); a=parameters(5); b=parameters(6);
% binomial coefficients calculation:
cp1=1; cp2=1; cp3=1; cp4=1;
for j=1:n
    c1(j)=(1-(1+q1)/j)*cp1;
    c2(j)=(1-(1+q2)/j)*cp2;
    c3(j)=(1-(1+q3)/j)*cp3;
    c4(j)=(1-(1+q4)/j)*cp4;
    cp1=c1(j); cp2=c2(j); 
    cp3=c3(j); cp4=c4(j);
end
% initial conditions setting:
x(1)=Y0(1); y(1)=Y0(2); z(1)=Y0(3); w(1)=Y0(4);
% calculation of phase portraits /numerical solution/:
for i=2:n
    x(i)=(alpha*(y(i-1)-x(i-1)+epsilon*x(i-1)-W_w(a,b,w(i-1))*x(i-1)))*h^q1 - memo(x, c1, i);
    y(i)=(x(i)-y(i-1)+z(i-1))*h^q2 - memo(y, c2, i);
    z(i)=(-beta*y(i)-gamma*z(i-1))*h^q3 - memo(z, c3, i);
    w(i)=(x(i))*h^q4 - memo(w, c4, i);
end
for j=1:n
    Y(j,1)=x(j);
    Y(j,2)=y(j);
    Y(j,3)=z(j);
    Y(j,4)=w(j);
end
T=h:h:TSim;
%