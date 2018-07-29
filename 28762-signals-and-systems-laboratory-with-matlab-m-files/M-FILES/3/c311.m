% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% Categorization according to the number of input and outputs 


% SISO
t=0:.01:3;
x=t.*cos(2*pi*t);

plot(t,x);
title('Input signal x(t)')

figure
plot(t+2,x);
title('Output signal y(t)')



% MISO
figure
t=0:.01:4;
x1=heaviside(t)-heaviside(t-3);
x2=t.*sin(t);
x3=t.*cos(t);

plot(t,x1,t,x2,':',t,x3,'--');
legend('x1(t)','x2(t)','x3(t)')

figure
y=x1+x2.*x3;
plot(t,y);
legend('Output y(t)')



% MIMO
figure
t=0:.01:4;
x1=heaviside(t);
x2=0.5*heaviside(t-1);

plot(t,x1,t,x2,':');
ylim([-0.1 1.4]);
legend('x1(t)','x2(t)')
title('Graph of input signals')

figure
y1=x1+x2;
y2=x1-x2;

plot(t,y1,t,y2, ':')
ylim([-0.1 2]);
legend('y1(t)', 'y2(t)')
title('Graph of output signals')



