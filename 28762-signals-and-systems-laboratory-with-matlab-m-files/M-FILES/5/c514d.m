% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%problem 4 -approximation & exponential coefficients

%x(t) =1, 0<t<1     T=2
%      =0,1<t<2 


%x(t)
syms t
t0= 0;
T=2;
w=2*pi/T;
x=heaviside(t)-heaviside(t-1);
ezplot(x,[0 2])
legend('x(t)')

%coefficients
figure
k=-20:20;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
a=eval(a);
stem(k,abs(a));
legend(' |a_k|, k=-20:20');
figure
stem(k,angle(a));
legend(' \angle a_k, k=-20:20');
%approximation
figure
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[0 2])
legend('Approximation with 41 terms')


%coefficients
figure
k=-100:100;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
a=eval(a);
stem(k,abs(a));
legend('|a_k|, k=-100:100');
figure
stem(k,angle(a));
legend('\angle a_k,  k=-100:100');
%approximation
figure
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[0 2])
legend('Approximation with 201 terms')

