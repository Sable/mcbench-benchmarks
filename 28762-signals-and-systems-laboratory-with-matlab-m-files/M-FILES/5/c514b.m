% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%problem 2

%x(t) =exp(-t^2), -3<t<3  T=6

%exponential coefficients 
syms t k
x=exp(-t^2);
t0=-3;
T=6;
w=2*pi/T;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
k1=-6:6;
ak=subs(a,k,k1);
stem(k1,abs(ak));
legend('|a_k|')
figure
stem(k1,angle(ak));
legend('\angle a_k')


%trigonometric coefficients 
figure
syms  n
a0=(1/T)*int(x,t0,t0+T);
stem(0,eval(a0))
legend('a_0');
figure
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
n1=1:10;
bn=subs(b,n,n1);
stem(n1,bn);
legend('b_n');
figure
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
cn=subs(c,n,n1);
stem(n1,cn);
legend('c_n');
ylim([-.1e-10 .1e-10])


%amplitudes and phases 
figure
A=sqrt(b.^2+c.^2);
An=subs(A,n,n1);
stem(n1,An)
legend('A_n')
figure
thita=atan2(-cn,bn);
stem(n1,thita)
legend('\theta_n')





