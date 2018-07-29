
% Chapter 14 - Poincare Maps and Nonautonomous Systems in the Plane.
% Programs_14g - Bifurcation diagram for the Duffing equation.
% Copyright Birkhauser 2013. Stephen Lynch.

% Make sure Programs_14f is in your directory.
clear
global Gamma;
Max=120;step=0.001;interval=Max*step;a=1;b=0;
% Ramp the amplitude up.
for n=1:Max
    Gamma=step*n;
    [t,x]=ode45('Programs_14f',0:(2*pi/1.25):(4*pi/1.25),[a,b]);
    a=x(2,1);
    b=x(2,2);
    rup(n)=sqrt((x(2,1))^2+(x(2,2))^2);
end
% Ramp the amplitude down.
for n=1:Max
    Gamma=interval-step*n;
    [t,x]=ode45('Programs_14f',0:(2*pi/1.25):(4*pi/1.25),[a,b]);
    a=x(2,1);
    b=x(2,2);
    rdown(n)=sqrt((x(2,1))^2+(x(2,2))^2);
end
hold on
rr=step:step:interval;
plot(rr,rup)
plot(interval-rr,rdown)
hold off
fsize=15;
axis([0 .12 0 2])
xlabel('\Gamma','FontSize',fsize)
ylabel('r','FontSize',fsize)
title('Bifurcation Diagram of the Duffing System. Bistable Region.')

% End of Programs_14g.