%minimum energy
function RunBVP6C
clc,tol=1e-10;
options = bvpset('stats','on','abstol',tol,'reltol',tol,'Nmax',1000);
solinit = bvpinit(linspace(0,6,3),5*ones(3,1));
sol = bvp6c(@odes,@bcs,solinit,options);
figure(1);plot(sol.x,sol.y);axis tight;
%% Main--------------------------------------------------------------------
function dydx = odes(x,y)
A=[1-2*cos(2*x) 0 1+2*sin(2*x);
    0 2 0;
    -1+2*sin(2*x) 0 1+2*cos(2*x);];
q=exp(x)*[-1+2*cos(2*x)-2*sin(2*x);
    -1;
    1-2*cos(2*x)-2*sin(2*x);];
dydx =A*y+q;
%% Ordinary Differential Equation------------------------------------------
function res = bcs(ya,yb)
res=eye(3)*ya+eye(3)*yb-[(1+exp(6));(1+exp(6));(1+exp(6))];
%% Boundary Conditions-----------------------------------------------------