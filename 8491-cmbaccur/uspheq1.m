function  du = uspheq1(x, u, la, kb, kk0)
% uspheq1() calculates the righthand side of ode equation for the u-function, which is r(x) * phi_beta(x),
% with phi_beta(x) the ultra-spherical function, see equation (36) of Zaldarriaga & Seljak.
% x is the independent variable and u = [du/dx; u] is the u-function and its derivative.
%
% input : vector x(1..np), matrix u(1..nv,1..np), with nv fixed to nv=2, an additional constant la,
%   parameters kb(1..np) and kk0, with np the number of parameter values.
% 1. du1/dx -> u(1) = u
% 2. du2/dx -> u(2) = du/dx
% output : a matrix nsteps x np :of u = du1/dx as a function of varable x and for all parameters values.  

% la is the angle number, kb the relative curvature constant of space, where kb=k2/beta, k2 = sqrt(abs(K))
% and K = H0^2*(omk - 1) and kk0 = sign(K), omk is total omega of the universe, K > 0 for closed space
% and K < 0 for open space
% see Seljak and Zaldarriaga, ApJ nr 494, 491-502 (1998) equation nr (36).
%
% D Vangheluwe 28 feb 2005, revised 2 may
% remark 1: remark that kb is a vector kb(1..np)
% remark 2: the number of steps is determined by the calling program, odeintp.m

la2 = la * (la + 1);
if kk0 < 0
   rx  = sinh(kb .* x) ./ kb;
else
   rx  = sin(kb .* x) ./ kb;
end
du(1,:) = u(2,:);
du(2,:) = u(1,:) .* (la2 ./(rx .^2) - 1);

return


