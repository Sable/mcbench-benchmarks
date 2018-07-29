% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%problem 3 -approximation & approximation percentage 

%x(t) =t, 0<t<1
%    =2-t,1<t<2 



%x(t)
syms t
x=t*(heaviside(t)-heaviside(t-1))+(2-t)*(heaviside(t-1)-heaviside(t-2))
ezplot(x,[0 2])
legend('x(t)');
t0= 0;
T=2;
Px=(1/T)*int(abs(x)^2,t0,t0+T)

%Approximations 
figure
k=-1:1;
w=2*pi/T ;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[0 2])
legend('Approximation with 3 terms ')
figure
ezplot(xx,[-2 4])
legend('Approximate signal in 3 periods')
Pa=sum((abs(a)).^2);
per=Pa/Px
percentage=eval(per)

figure
k=-2:2;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[0 2])
legend('Approximation with 5 terms')
Pa=sum((abs(a)).^2);
per=Pa/Px
percentage=eval(per)

figure
k=-3:3;
a=(1/T)*int(x*exp(-j*k*w*t) ,t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[0 2])
legend('Approximation with 7 terms')
Pa=sum((abs(a)).^2);
per=Pa/Px;
percentage=eval(per)

figure
k=-8:8;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[0 2])
legend('Approximation with 17 terms')
Pa=sum((abs(a)).^2);
per=Pa/Px;
percentage=eval(per)

