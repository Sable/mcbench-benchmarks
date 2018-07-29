% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Approximation criterion  by FS 


% x(t)=t^3 , -1<t<1 
syms t
x=t^3;
t0=-1;
T=2;
w=2*pi/T;
Px=(1/T)*int(abs(x)^2,t0,t0+T);
ezplot(x,[-1 1]);
legend('x(t)')

% Approximations and approximation percentages
figure
k=-3:3;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[-1 1]);
legend('Approximation for k=-3:3')
Pa=(abs(a)).^2;
percentage=sum(Pa/Px);
eval(percentage)
% or alternatively  
Pa=sum((abs(a)).^2);
per=Pa/Px;
eval(per)

figure
k=-20:20;
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[-1 1]);
legend( 'Approximation for k=-20:20');
Pa=(abs(a)).^2;
percentage=sum(Pa/Px);
eval(percentage)

figure
k=-100:100;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[-1 1]);
legend(' Approximation for k=-100:100');
Pa=sum((abs(a)).^2);
per=Pa/Px;
eval(per)
