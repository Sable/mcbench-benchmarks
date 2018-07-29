function [c,ceq] = nonlcon_dist(x0,u,d,N,C)

parameters_dist
% States
x = x0(:,0*C+1:1*C);
y = x0(:,1*C+1:2*C);
L = x0(:,2*C+1);
V = x0(:,2*C+2);
T = x0(:,2*C+3);

% Manipulations
P = u(0*N+1:1*N);
U = u(1*N+1:2*N);
W = u(2*N+1:3*N);
Q = u(3*N+1:4*N);

% Disturbances
z  = d(:,0*C+1:1*C);
F  = d(:,1*C+1);
HF = d(:,1*C+2);

model_dist

ceq = [M(:); E(:); Sx(:); Sy(:); H(:)];
c   = [];

