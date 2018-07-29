% Chapter 12 - Bifurcations of Nonlinear Systems in the Plane.
% Programs_12d - Hopf Bifurcation.
% Copyright Birkhauser 2013. Stephen Lynch.

% Animation of Hopf bifurcation of a limit cycle from the origin.
% NOTE: Programs_12c must be in the same directory as Programs_12d.
clear
global mu
for j = 1:48 
    F(j) = getframe;
    mu=j/40-1;   % mu goes from -1 to 0.2.
options = odeset('RelTol',1e-4,'AbsTol',1e-4);
x0=0.5;y0=0.5;
[t,x]=ode45(@Programs_12c,[0 80],[x0 y0],options);  
plot(x(:,1),x(:,2),'b');  
axis([-1 1 -1 1])
fsize=15;
set(gca,'XTick',-1:0.2:1,'FontSize',fsize)
set(gca,'YTick',-1:0.2:1,'FontSize',fsize)
xlabel('x(t)','FontSize',fsize)
ylabel('y(t)','FontSize',fsize)
title('Hopf Bifurcation','FontSize',15);
 
 F(j) = getframe;

end

movie(F,5)

% End of Programs_12d.

