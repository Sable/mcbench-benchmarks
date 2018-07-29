% Chua_Time_Series - Time series plot.
% Copyright Springer 2013 Stephen Lynch.
Chua=@(t,x) [15*(x(2)-x(1)-(-(5/7)*x(1)+(1/2)*(-(8/7)-(-5/7))*(abs(x(1)+1)-abs(x(1)-1))));x(1)-x(2)+x(3);-25.58*x(2)];
options = odeset('RelTol',1e-4,'AbsTol',1e-4);
[t,xb]=ode45(Chua,[0 100],[-1.6,0,1.6],options);
plot(t,xb(:,2),'r')
title('Time series')
fsize=15;
set(gca,'xtick',0:20:100,'FontSize',fsize)
set(gca,'ytick',-0.6:0.2:0.6,'FontSize',fsize)
xlabel('time','FontSize',fsize)
ylabel('y(t)','FontSize',fsize)


