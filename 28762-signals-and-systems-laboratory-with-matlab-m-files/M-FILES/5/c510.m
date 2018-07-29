% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

% Symmetry


% 	Even symmetry 

syms x t k T 
w=2*pi/T;
c1=(2/T)*int(x*sin(k*w*t),t,-T/2,0);

c2=(2/T)*int(x*sin(k*w*t),t,0,T/2);
c=c1+c2

t0=-2;
T=4;
w=2*pi/T;
syms t
x=t^2;
k=-5:5;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
stem(k,eval(a))
legend('a_k')



% 	Odd symmetry  
figure
syms x t k T
w=2*pi/T;
b1=(2/T)*int(-x*cos(k*w*t),t,-T/2,0);

b2=(2/T)*int(x*cos(k*w*t),t,0,T/2);
b=b1+b2

t0=-2;
T=4;
w=2*pi/T;
syms t
x=t;
k=-5:5;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);

stem(k,imag(eval(a)))
legend('a_k')
