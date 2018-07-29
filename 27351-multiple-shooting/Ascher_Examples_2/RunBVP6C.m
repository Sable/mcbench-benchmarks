%minimum energy
function RunBVP6C
clc,tol=1e-10;
options = bvpset('stats','on','abstol',tol,'reltol',tol,'Nmax',1000);
x=0:0.1:1;
y(:,1)=x.^0;
y(:,2)=x.^0;
y(:,4)=-10*x.^0;
y(:,3)=-4.5*x.^2+8.91*x+1;
y(:,5)=-4.5*x.^2+9*x+0.91;

solinit = bvpinit(x,y);
sol = bvp6c(@odes,@bcs,solinit,options);
figure(1);plot(sol.x,sol.y);axis tight;
%% Main--------------------------------------------------------------------
function dydx = odes(x,y)
dydx = [0.5*y(1)*(y(3)-y(1))/y(2);
    -0.5*(y(3)-y(1));
    (0.9-1000*(y(3)-y(5))-0.5*y(3)*(y(3)-y(1)))/y(4);
    0.5*(y(3)-y(1));
    -100*(y(5)-y(3));];
%% Ordinary Differential Equation------------------------------------------
function res = bcs(ya,yb)
res=[ya(1)-1;
    ya(2)-1;
    ya(3)-1;
    ya(4)+10;
    yb(5)-yb(3);];
%% Boundary Conditions-----------------------------------------------------