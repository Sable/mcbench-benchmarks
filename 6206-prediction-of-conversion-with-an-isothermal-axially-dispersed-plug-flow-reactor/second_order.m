global Pe Da N


Di=0.005;
k=0.01;
L=1;
u=0.01;

Pe=L*u/Di;
Da=k*L/u;

Pe 
Da

N=fsolve('shoot2',[0.1 -0.1],optimset('TolFun',1e-3,'Display','iter'));

[t y]=ode45('goveqn2',[0 1],N);

1-y(end,1)
plot(t,y(:,1),'r')