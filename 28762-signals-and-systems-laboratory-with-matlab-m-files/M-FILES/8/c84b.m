% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%  	System response to sinusoidal inputs 

t=0:.1:30;
x2=sin((pi/2)*t+pi/4);
plot(t,x2);
ylim([-1.5 1.5]);
legend('input x_2(t)'); 

figure
w0=pi/2;
Hw0=(3*(j*w0)^2+4j*w0+2)/(-w0^2+j*w0+3)
mag=abs(Hw0)
ph=angle(Hw0)
y2=1*mag*sin(w0*t+pi/4+ph);
plot(t,y2);
legend('output signal y_2(t)')
ylim([-6 7]);

figure
num=[3 4 2];
den=[1 1 3];
yls=lsim(num,den,x2,t);
plot(t,yls);
legend('system response by lsim')

figure
plot(t,x2,t,y2,'o')
legend('x(t)','y(t)')
ylim([-6 8]);
