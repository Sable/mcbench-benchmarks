function f=shoot2(N)

global Pe Da

[t y]=ode45('goveqn2',[0 1],N);

f(1)=1-y(1,1)+1/Pe*y(1,2);
f(2)=y(end,2);
