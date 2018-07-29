k=1/(2*sqrt(log(2)));
x=0:30/1999:30; 
dx=x(2)-x(1);
a1=1.0; t1=5; w1=1.3;
y1=a1*exp(-((x-t1)/(w1*k)).^2);
a2=1.0; t2=15.0; w2=1.3;
y2=a2*(1+4*((x-t2)/w2).^2).^(-1);
a3=1.0; t3=25;
y3=a3*ones(size(x))./(1+exp(-3.0*(x-t3)));
y=y1+y2+y3;
noise=rand(size(y));
y=y+(noise-0.5)*0.01;

figure
subplot(2,2,1)
plot(x,y);
title('noisy data');

subplot(2,2,3)
plot(x(1:end-1)+(x(2)-x(1)),diff(y)/dx);
title('differentiation (diff)');

subplot(2,2,2)
plot(x,derivative_cwt(y,'gaus1',16,dx,1));
title('differentiation (cwt)');


subplot(2,2,4)
plot(x,derivative_dwt(y,'spl',4,dx,1));
title('differentiation (dwt)');
