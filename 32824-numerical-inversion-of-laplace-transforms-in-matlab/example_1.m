% example_1 - inversion of a irrational fraction F(s) 
clear, close all
[t1,ft1]=INVLAP('tanh(s)/s',0.01,20,1000); 
[t2,ft2]=INVLAP('tanh(s)/s',0.01,20,2000,6,280,59);
figure(3)
set(3,'color','white')
subplot(2,1,1)
plot(t1,ft1), grid on, zoom on
xlabel('t [s]'), ylabel('f(t)')
title('rectangular periodic wave')
subplot(2,1,2)
plot(t2,ft2), grid on, zoom on
xlabel('t [s]'), ylabel('f(t)')
title('improved accuracy')