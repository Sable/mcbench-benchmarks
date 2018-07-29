% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%problem 1

%x(t) =t*exp(-t), 0<t<T , T=6


%x(t),0<t<4T
t=0:.1:6;
x=t.*exp(-t);
xp=repmat(x,1,4);
tp=linspace(-6,18,length(xp));
plot(tp,xp)
legend('x(t) in 4 periods')


%'Approximations
figure %exponential 
t0=0;
T=6;
w=2*pi/T;
syms t
x=t.*exp(-t);
k=-40:40;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[-6 18]);
legend('approximate signal in 4 periods using a_k')

figure %trigonometric 
a0=(1/T)*int(x,t0,t0+T);
n=1:81;
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[-6 18]);
legend('approximate signal in 4 periods using b_k ,c_k' )

