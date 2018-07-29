% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Problem 6- System response to exponential input signal

num=[-1 4 2];
den=[1 2 1];
t=0:.1:5;
x=3*t.*exp(-t);
y=lsim(num,den,x,t);
plot(t,y,t,x,'o')
legend('y(t)',' x(t)')

