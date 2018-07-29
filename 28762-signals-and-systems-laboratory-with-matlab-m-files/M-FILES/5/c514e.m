% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%problem 5 -approximation & trigonometric coefficients

%x(t) =1, 0<t<1     T=2
%      =0,1<t<2 

%x(t)
syms t
x=(heaviside(t)-heaviside(t-1)); 
t0=0;
T=2;
w=2*pi/T;

%coefficients
n=1:40;
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T); 
stem(n,eval(b))
legend('b_n')
figure
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
stem(n,eval(c))
legend('c_n  n=1:40')
a0=(1/T)*int(x,t0,t0+T);
%approximation
figure
xx=a0+sum(b.*cos(n*w*t))+sum(c.*sin(n*w*t));
ezplot(xx,[0 2])
legend('Approximation with 41 terms')

%coefficients
figure
n=1:200;
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
stem(n,eval(c));
legend('c_n  n=1:200')
%approximation
figure
xx=a0+sum(b.*cos(n*w*t))+sum(c.*sin(n*w*t));
ezplot(xx,[0 2])
legend('Approximation with 201 terms')
