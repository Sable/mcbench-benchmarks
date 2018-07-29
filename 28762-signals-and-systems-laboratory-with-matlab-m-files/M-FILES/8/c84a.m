% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%  	System response to sinusoidal inputs 


t=0:.1:30;
x1=3*cos(t+pi/3);
plot(t,x1);
legend('input signal x(t)')
ylim([-4 4]);

figure
w0=1;
Hw0=(3*(j*w0)^2+4j*w0+2)/(-w0^2+j*w0+3)
magn=abs(Hw0)
phas=angle(Hw0)
y1=3*abs(Hw0)*cos(t+pi/3+angle(Hw0));
plot(t,y1);
legend('system response')
ylim([-7 7]);

figure
num=[3 4 2];
den=[1 1 3];
yls=lsim(num,den,x1,t);
plot(t,yls);
legend('system response by lsim')


figure
plot(t,x1,t,y1,'o')
legend('x(t)','y(t)')
ylim([-7 9]);
