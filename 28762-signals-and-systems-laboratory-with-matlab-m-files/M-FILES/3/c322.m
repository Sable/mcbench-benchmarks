% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% Static or dynamic

t1=-3:.1:0;
x1=zeros(size(t1));
t2=0:.1:1;
x2=ones(size(t2));
t3=1:.1:3;
x3=zeros(size(t3));
t=[t1 t2 t3];
x=[x1 x2 x3];
plot(t,x);
ylim([-0.1 1.1]);
legend('x(t)')



%static
figure
plot(t,3*x);
ylim([-0.1 3.1]);
legend('y(t)')



figure
n=-1:3;
x=[0 1 2 3 4];
stem(n,x);
axis([-1.1 3.1 -.1 4.1]);
legend('x[n]')


%static
figure
y=x.^2;
stem(n,y);
axis([-1.1 3.1 -.1 16.1]);
legend('y_1[n]')


%dynamic
figure
a=1/2; 
y=upsample(x,1/a)
stem(-2:7,y)
axis([-2.2 7.2 -.1 4.1]);
legend('y_2[n]')
