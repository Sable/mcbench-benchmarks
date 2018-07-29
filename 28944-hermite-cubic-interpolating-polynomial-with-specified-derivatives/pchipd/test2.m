a = -10;
b = 10;
x = linspace(a,b,7); 
f = @(x) 1./(1+exp(-x));
df = @(x) f(x).*(1-f(x));
t = linspace(a,b,50);
r = f(t);
p = pchip(x,f(x),t);
s = spline(x,f(x),t);
q = pchipd(x,f(x),df(x),t);
plot(t,r,'k',x,f(x),'o',t,p,'-',t,s,'-.',t,q,'--')
legend('true','data','pchip','spline','pchipd',4)
