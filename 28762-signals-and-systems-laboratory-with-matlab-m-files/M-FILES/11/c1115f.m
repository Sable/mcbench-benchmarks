% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 6- system response to exp(-0.1t)cos(t)

num=[1  0 -1];
den=[1 2 3 4];
H=tf(num,den);

t=0:.1:60;
x=exp(-0.1*t).*cos(t);

y=lsim(H,x,t);

plot(t,y);
legend('System response y(t)')
