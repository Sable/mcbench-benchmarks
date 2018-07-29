% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 


% problem1 - integrator system

%linear
syms t r   
x1=heaviside(r)-heaviside(r-2);
x2=heaviside(r)-heaviside(r-3);

a1=2;
a2=3;
z=a1*x1+a2*x2;
y1=int(z,r,-inf,t);

z1=int(x1,r,-inf,t);
z2=int(x2,r,-inf,t);
y2=a1*z1+a2*z2;

t=-5:0.01:10;
y1=subs(y1,t);
y2=subs(y2,t);
subplot(211);
plot(t,y1);
subplot(212);
plot(t,y2);

% dynamic
figure
syms t r
x=heaviside(r)-heaviside(r-2);
y=int(x,r,-inf,t);
t=-5:0.01:10;
x=subs(x,t);
y=subs(y,t);
subplot(211);
plot(t,x);
legend('x(t)')
ylim([-0.1 1.1]);
subplot(212);
plot(t,y);
legend('y(t)')
ylim([-0.1 2.1]);


%time invariant
figure
t=-5:.01:10;
x=heaviside(t)-heaviside(t-2);
y=t.*heaviside(t)-(t-2).*heaviside(t-2);
subplot(211);
plot(t,x);
ylim([-0.1 1.1]);
legend('x(t)')
subplot(212);
plot(t,y);
ylim([-0.1 2.1]);
legend('y(t)')

figure
plot(t+3,y) 
ylim([-0.1 2.1]);
legend('y(t-3)')

figure
syms t r
x=heaviside(r-3)-heaviside(r-5);
y=int(x,r,-inf,t);
tt=-5:.001:10;
y2=subs(y,t,tt);
plot(tt,y2)
ylim([-0.1 2.1]);
legend('S[x(t-3)]')

%unstable
figure
syms t r
x=heaviside(r);
y=int(x,r,-inf,t)

t=-5:.01:10;
y=subs(y,t);
plot(t,y);
legend('y(t)')

syms t
y=t*heaviside(t);
limit(y,t,inf)


