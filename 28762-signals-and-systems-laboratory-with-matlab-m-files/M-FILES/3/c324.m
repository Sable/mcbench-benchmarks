% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% time invariant or time variant



%time variant
t=-5:.001:10;
p=heaviside(t)-heaviside(t-5);
y=t.*exp(-t).*p;
plot(t,y)
ylim([-.05 .4]);
legend('y(t)') 

figure
plot(t+3,y)
ylim([-.05 .4]);
legend('y(t-3)')

figure
t=-5:.001:10;
p=heaviside(t-3)-heaviside(t-8);
y2=t.*exp(-t).*p;
plot(t,y2)
ylim([-.01 .2]);
legend('S[x(t-3)]')


%time invariant
figure
t=-5:.01:20;
p=heaviside(t-1)-heaviside(t-11);
y=1-2*cos(t-1).*p;
plot(t,y)
legend('y(t)')

figure
p=heaviside(t)-heaviside(t-10);
x=cos(t).*p;
plot(t+1,1-2*x)
legend('y(t)')

figure
plot(t+4,y)
legend('y(t-4)')

figure
p=heaviside(t-4)-heaviside(t-14);
x=cos(t-4).*p;
plot(t,x)

figure
p=heaviside(t-4)-heaviside(t-14);
x=cos(t-4).*p;
plot(t+1,1-2*x)

figure
t=-5:.01:20;
p=heaviside(t-5)-heaviside(t-15);
y2=1-2*cos(t-5).*p ;
plot(t,y2) ;
legend('S[x(t-4)]')



%time variant
figure
t=-5:.1:10;
x=heaviside(t+2)-heaviside(t-2);
plot(t,x);
ylim([-.1 1.1]);

figure
plot((1/2)*t,x);
ylim([-.1 1.1]);

figure
plot((1/2)*t+2,x);
ylim([-.1 1.1]);
legend('y_1(t)')

figure
plot(t+2,x);
ylim([-.1 1.1]);
legend('x(t-2)')

figure
t=-5:.1:10;
x2=heaviside(t)-heaviside(t-4);
plot(t,x2);
ylim([-.1 1.1]);

figure
plot((1/2)*t,x2);
ylim([-.1 1.1]);
legend('y_2(t)')




%shift invariant
figure
n=0:5;
x=0.8.^n; 
y=x.^2;
stem(n,y);
xlim([-.1 5.1])
legend('y[n]')

figure
stem(n+2,y)
legend('y[n-2]')
xlim([1.9 7.1])

figure
n=2:7;
y2=(0.8.^(n-2)).^2;
stem(n,y2);
xlim([1.9 7.1])
legend('S[x[n-2]]')




