% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Step response of discrete time system


% H(z)=(0.1z-0.1)/(z^2-1.5z+0.7)

num=[.1 .1];
den=[1 -1.5 0.7];
dstep(num,den)

figure
s=dstep(num,den)
stairs(0:length(s)-1,s);
legend('Step response')

figure
n=0:80;
s=dstep(num,den,n);
stairs(n,s)
legend('Step response')


% second way
figure
stepz(num,den)

