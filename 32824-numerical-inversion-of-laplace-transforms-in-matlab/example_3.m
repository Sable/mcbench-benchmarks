% example_3 - inversion of a fractional F(s) in symbolic form
clear, close all
syms D1 alfa1 R1 s
% parameters of the network with constant phase element
I=0.25;  Rs=0.1;  R1=100;  D1=1;  alfa1=-0.7;
% F(s) in symbolic form
F1=I*(Rs+(R1*D1*s^alfa1/(R1+D1*s^alfa1)))*(1-exp(-4000*s))/s;
% F(s) as a string
F1=char(F1);                     
% parameters of the fractional control system
k=20.5;  a1=3.7343;  alfa1=1.15;  a2=0.8;  alfa2=2.2;  a3=0.5;  alfa3=0.9;
F2=(k+a1*s^alfa1)/(k+1+a1*s^alfa1+a2*s^alfa2+a3*s^alfa3)/s; % F(s) in symbolic form
F2=char(F2);      % F(s) as a string
[t1,ft1]=INVLAP(F1,0.01,1e4,1000,6,39,89);
[t2,ft2]=INVLAP(F2,0.01,5,200);
figure(4)
set(4,'color','white')
subplot(2,1,1)
plot(t1,ft1), grid on, zoom on
xlabel('t [s]'), ylabel('f(t)')
title('response to the input current impulse')
subplot(2,1,2)
plot(t2,ft2), grid on, zoom 
xlabel('t [s]'), ylabel('f(t)')
title('step response of a fractional control system')