% example_2 - inversion of a fractional F(s)
clear, close all
[t1,ft1]=INVLAP('1/(sqrt(s)*s)',0.01,5,200,6,40,20);
[t2,ft2]=INVLAP('(20.5+3.7343*s^1.15)/(21.5+3.7343*s^1.15+0.8*s^2.2+0.5*s^0.9)/s',0.01,5,200);
figure(4)
set(4,'color','white')
subplot(2,1,1)
plot(t1,ft1), grid on, zoom on
xlabel('t [s]'), ylabel('f(t)')
%title('
subplot(2,1,2)
plot(t2,ft2), grid on, zoom 
xlabel('t [s]'), ylabel('f(t)')
title('step response of a fractional control system')