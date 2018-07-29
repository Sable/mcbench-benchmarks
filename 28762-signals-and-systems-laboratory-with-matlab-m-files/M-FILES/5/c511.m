% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

% Parseval's identity 


% average power of x(t)=sin(t)	
syms t 
x=sin(t);
T=2*pi;
t0=0;
P=(1/T)*int(abs(x)^2,t0,t0+T);
P=eval(P)

w=2*pi/T;
k=-6:6;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T)
eval(a)
P=sum((abs(a)).^2);
eval(P)

a0=(1/T)*int(x,t0,t0+T);
P=a0^2+ 2*sum((abs(a(7:13)).^2));
eval (P)


% average power of x(t)=t , -1<t<1 
syms t
x=t;
t0=-1;
T=2;
w=2*pi/T;
P=(1/T)*int(abs(x)^2,t0,t0+T)

k=-3:3;
a=(1/T)*int(x*exp(-j*k*w*t) ,t,t0,t0+T)
P=sum((abs(a)).^2);
eval(P)

k=-8:8;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
P=sum((abs(a)).^2);
eval(P)

k=-20:20;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
P=sum((abs(a)).^2);
eval(P)

k=-100:100;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
P=sum((abs(a)).^2);
eval(P)
