% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Step response of discrete time system


% H(z)=(0.1z-0.1)/(z^2-1.5z+0.7)

num=[.1 .1];
den=[1 -1.5 0.7];
dimpulse(num,den)

figure
h=dimpulse(num,den);
stairs(0:length(h)-1,h)
legend('Impulse response')

figure
n=0:50;
y=dimpulse(num,den,n);
stairs(n,y)
legend('h[n]')


% second way
num=[.1 .1];
den=[1 -1.5 0.7];
impz(num,den)
