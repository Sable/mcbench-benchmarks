% Fig. 8.5   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%

clear all;
close all;

th=0:.1:pi;
Im=sin(th);
Re=cos(th);

figure(1)
plot(Re,Im,'-',.5*Re,.5*Im,'--'),grid
axis([-1 1 -.5 1.5])
axis('square')
hold on
plot(1,0,'x')
plot(.6,0,'x')
plot(.3,0,'x')
plot(0,0,'x')
plot(-.5,0,'x')
plot(-1,0,'x')
j=sqrt(-1);
p=[exp(j*pi/4) exp(-j*pi/4)];
plot(p,'x')
p2=[exp(j*pi/2) exp(-j*pi/2)];
plot(p2,'x')
p3=1.2*[exp(j*pi/2) exp(-j*pi/2)];
plot(p3,'x')
p4=.5*[exp(j*pi/4) exp(-j*pi/4)];
plot(p4,'x')
p5=.5*[exp(j*pi/2) exp(-j*pi/2)];
plot(p5,'x')
p6=.5*[exp(j*3*pi/4) exp(-j*3*pi/4)];
plot(p6,'x')
title('Fig. 8.5  Time sequences associated with poles in the z-plane')
hold off

figure(2) % This figure creates four of the time responses 
num=[1  0];
den=[1 -1];
N=11;
n=0:N-1;
y=dimpulse(num,den,N);
Ny=size(y);
subplot(2,2,1)
axis([1 10 -1.5 1.5])
zero=zeros(Ny);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = +1')

den=[1 -.6];
subplot(2,2,2)
y=dimpulse(num,den,N);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = +.6')

den=[1 -.3];
subplot(2,2,3)
y=dimpulse(num,den,N);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = +.3')

den=[1 0];
subplot(2,2,4)
y=dimpulse(num,den,N);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = 0')

figure(3)   % This figure creates four more of the time responses
num=[1  0];
j=sqrt(-1);
p=[exp(j*pi/4) exp(-j*pi/4)];
den=poly(p);
N=11;
n=0:N-1;
y=.67*dimpulse(num,den,N);
Ny=size(y);
subplot(2,2,1)
axis([1 10 -1.5 1.5])
zero=zeros(Ny);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = exp(+-j*45 deg)')

p=[exp(j*pi/2) exp(-j*pi/2)];
den=poly(p);
subplot(2,2,2)
y=dimpulse(num,den,N);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = exp(+-j*90 deg)')

den=[1  1];
subplot(2,2,3)
y=dimpulse(num,den,N);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = -1')

p=1.2*[exp(j*pi/2) exp(-j*pi/2)];
den=poly(p);
subplot(2,2,4)
y=.5*dimpulse(num,den,N);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = 1.2*exp(+-j*90 deg)')

figure(4)  % This figure creates four more of the time responses
num=[1  0];
j=sqrt(-1);
p=.5*[exp(j*pi/4) exp(-j*pi/4)];
den=poly(p);
N=11;
n=0:N-1;
y=dimpulse(num,den,N);
Ny=size(y);
subplot(2,2,1)
axis([1 10 -1.5 1.5])
zero=zeros(Ny);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = .5*exp(+-j*45 deg)')

p=.5*[exp(j*pi/2) exp(-j*pi/2)];
den=poly(p);
subplot(2,2,2)
y=dimpulse(num,den,N);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = .5*exp(+-j*90 deg)')

p=.5*[exp(j*3*pi/4) exp(-j*3*pi/4)];
den=poly(p);
subplot(2,2,3)
y=dimpulse(num,den,N);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = .5*exp(+-j*135 deg)')

den=[1 .5];
subplot(2,2,4)
y=dimpulse(num,den,N);
plot(n,y,'*',n,y,'--',n,zero,'-')
title('z = -.5')

