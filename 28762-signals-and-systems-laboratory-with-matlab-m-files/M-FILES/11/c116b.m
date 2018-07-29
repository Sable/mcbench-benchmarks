% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 	Step response


% H(s)=10/(s^2+2s+10)

n=10;
d=[1 2 10]
H=tf(n,d);
step(H)

figure
t=0 :.1 :10 ;
s=step(H,t)
plot(t,s);
title('Step response')

Hzpk=zpk(H);
step(Hzpk)


% second way
figure
syms t s
x=heaviside(t);
X=laplace(x,s);

H=10/(s^2+2*s+10);

Y=H*X;
y=ilaplace(Y,t);

t=0:.1:6;
s=subs(y,t);
plot(t,s)
title('Step response')



% third way


n=10;
d=[1 2 10];

t=0:.1:6;
x=ones(size(t));

s=lsim(n,d,x,t);
plot(t,s);
legend('s(t)');

