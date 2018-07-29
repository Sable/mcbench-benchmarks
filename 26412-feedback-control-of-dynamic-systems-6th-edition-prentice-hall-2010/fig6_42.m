% Fig. 6.42   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

num=86*conv([1 1],[1 2 43.25]);
p=conv([1 2 82],[1 2 101]);
den=conv([1 0 0],p);
w=logspace(-1,2,1000);
[mag,phas]=bode(num,den,w);
[re,im]=nyquist(num,den,w);

ii=200:1000;
plot(re(ii),im(ii));
xlabel('Real');
ylabel('Imaginary');
axis([-1.2 1.2 -1.2 1.2])
axis('square')
nicegrid;
hold on;

% add circle at mag = 1
w2=0:.05:2*pi;
x=cos(w2);
y=sin(w2);
plot(x,y,'r--')
title('Figure 6.42 Nyquist plot of the complex system in Ex 6.13.');
hold off;

