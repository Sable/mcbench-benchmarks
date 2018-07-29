% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%  	response of an ideal low pass filter with B=10 rad/sec to
%  	x(t)=3cos(4t+pi/3)+5sin(15t+pi/4)


B= 10;
td=.05;
syms w t
H=exp(-j*w*td)*(heaviside(w+B)-heaviside(w-B));
w=4;
Hw0_1=eval(H);
w=15;
Hw0_2=eval(H);
mag1=abs(Hw0_1)
phas1=angle(Hw0_1)
mag2=abs(Hw0_2)
phas2=angle(Hw0_2)
y=3*mag1*cos(4*t+pi/3+phas1)+5*mag2*sin(15*t+pi/4+phas2)


% 2nd method
B= 10;
td=0.05;
syms t w
H=exp(-j*w*td)*(heaviside(w+B)-heaviside(w-B));
x=3*cos(4*t+pi/3)+5*sin(15*t+pi/4);
X=fourier(x,w);
Y=H*X;
Y=simplify(Y);
y=ifourier(Y,t)
ezplot(y,[0 10])
t=0:.1:10;
ya=3*cos(4*t+1/3*pi-1/5); 
hold on
plot(t,ya,':o')
legend('2nd way','1 st way')
ylim([-3.5 5]);
hold off

