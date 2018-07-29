% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 8- Discrete time system


% a)delay of two units 
num=[1 0 0];
den=[1 .2 .01];
Ts=0.1; 
H1=tf(num,den,Ts);
H2=tf(num,den,Ts,'inputdelay',2)

% b)impulse response of H1(s)
n=0:8;
h=dimpulse(num,den,n);
stairs(n,h)
legend('h[n]')

% c)impulse response of H2(s)
figure
num=1;
h2=dimpulse(num,den,n);
stairs(n,h2)
legend('h[n-2]');
