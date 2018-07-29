% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 5- impulse response of a continious time system 


num=conv([1 2],[1 -3]);
den=[1 9 26 24];
t=0:.1:3;

h=impulse(num,den,t);

plot(t,h)
title('Impulse response')

%second way
figure

syms s
H=(s+2)*(s-3)/(s^3+9*s^2+26*s+24);

h=ilaplace(H)

ezplot(h,[0 3])
ylim([-.4 1]);

