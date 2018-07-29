% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%problem 6 -approximation &  coefficients of cosine with phase form

%x(t) =1, 0<t<1     T=2
%      =0,1<t<2 

%x(t)
syms t
x=(heaviside(t)-heaviside(t-1)) 
%coefficients
t0=0;
T=2;
w=2*pi/T;
n=1:40;
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T)
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T)
A=sqrt(b.^2+c.^2);
stem(n,eval(A));
legend('A_n  n=1:40')
figure
thita= atan2(-eval(c),eval(b)); 
stem(n,thita)
legend('\theta_n  n=1:40')
%approximation
figure
a0=(1/T)*int(x,t0,t0+T);
xx=a0+sum(A.*cos(n*w*t+thita))
ezplot(xx,[0 2])
legend('Approximation with 41 terms')


%coefficients
figure
n=1:200;
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
A=sqrt(b.^2+c.^2);
stem(n,eval(A));
legend('A_n  n=1:200')
figure
thita= atan2(-eval(c),eval(b)); 
stem(n,thita)
legend('\theta_n  n=1:200')
%approximation
figure
xx=a0+sum(A.*cos(n*w*t+thita))
ezplot(xx,[0 2])
legend('Approximation with 201 terms')
