% Author: Housam Binous

% Forced Duffing Oscillator

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

close all
clear
clc

global gamma omega epsilon GAM OMEG

gamma=0.1;
omega=1;
epsilon=0.25;
OMEG=2;

% we get chaos and a strange attractor if the driving force GAM=1.5
% Poincaré section is a complicated curve namely a fractal

GAM=1.5;

[t x]=ode45(@duffing,0:2*pi/OMEG/100:4000,[0 1]);

figure(1)
plot(t(2000:6000),x(2000:6000,1),'r')
axis tight
title('time series')
figure(2)
plot(x(2000:10000,2),x(2000:10000,1),'b')
axis tight
title('phase space')
figure(3)
for i=5000:100:127300
    n=(i-4900)/100;
    x1(n)=x(i,2);
    x2(n)=x(i,1);
end
plot(x1(:),x2(:),'g.')
axis tight
title('Poincaré section')

% We get a limit cycle when the driving force GAM=0.5
% Poincaré section is a sinle point

GAM=0.5;

[t x]=ode45(@duffing,0:2*pi/OMEG/100:4000,[0 1]);

figure(4)
plot(t(2000:6000),x(2000:6000,1),'r')
axis tight
title('time series')
figure(5)
plot(x(5000:10000,2),x(5000:10000,1),'b')
axis tight
title('phase space')
figure(6)
for i=5000:100:127300
    n=(i-4900)/100;
    x1(n)=x(i,2);
    x2(n)=x(i,1);
end
plot(x1(:),x2(:),'g.')
axis([-2 2 -2 2])
title('Poincaré section')
