% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 11 - State space representation


%state space model from Transfer Function
num=[1 0 2];
den=[1 1 4 2];
[A,B,C,D]=tf2ss(num,den)

sys=ss(A,B,C,D);


%Impulse response
t=0:.1:20;
h=impulse(sys,t);

plot(t,h)
legend('Impulse response')




%Impulse response
figure
s=step(sys,t);

plot(t,s)
legend(' Step response')




%System response to v(t)= 2t , 0<t<2
%                       =8-2t, 2<t<4
figure

t1=0:.1:2;
t2=2.1:.1:4;
t3=4.1:.1:20;
t=[t1 t2 t3];
v1=2*t1;
v2=8-2*t2;
v3=zeros(size(t3));
v=[v1 v2 v3];

y=lsim(sys,v,t);

plot(t,y);
legend('System response')




% State trajectories–input signal delta(t)
figure
[y,t,x]=impulse(sys,t);

plot(t,x(:,1),t,x(:,2),'+',t,x(:,3),'o')
legend('x_1(t)','x_2(t)','x_3(t)')
title('State trajectories–input signal \delta(t)')




% State trajectories–input signal v(t)
figure
[y,t,x]=lsim(sys,v,t);

plot(t,x(:,1),t,x(:,2),':+',t,x(:,3),':o')
legend('x_1(t)','x_2(t)','x_3(t)')
title('State trajectories –input signal x(t))')

