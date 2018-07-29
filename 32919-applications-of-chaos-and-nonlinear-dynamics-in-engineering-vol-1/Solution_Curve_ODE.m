% Solution_Curve_ODE.
% Copyright Springer 2013. Stephen Lynch.
% See Figure 1.2.
deqn=@(t,c) .00713*(4-c)^2*(1-c/2);
[t,ca]=ode45(deqn,[0 400],0);
plot(t,ca(:,1));
axis([0 400 0 3]);
fsize=15;
set(gca,'xtick',0:100:400,'FontSize',fsize);
set(gca,'ytick',0:1:3,'FontSize',fsize);
xlabel('t','FontSize',fsize);
ylabel('c(t)','FontSize',fsize);