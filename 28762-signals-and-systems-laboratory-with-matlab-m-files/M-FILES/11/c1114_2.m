% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Discrete Time State Space models 


% state space model
A =[ .9 .7;  -1.5 -.2];
B=[1; 0];
C=[1 2];
D=0.1;
Ts=0.1; 
sys=ss(A,B,C,D,Ts)


%extraction of the model matrices 
[A,B,C,D]=ssdata(sys)


% Transfer Function from state space model 
[num,den]=ss2tf(A,B,C,D,1)
H=tf(num,den,Ts)


% Impulse response 
n=0:80;
h=dimpulse(A,B,C,D,1,n);
stairs(n,h)
legend('Impulse response h[n]')


% Step response
figure
s=dstep(A,B,C,D,1,n)
stairs(n,s)
title('Step response')


% System response to v[n]=0.9.^n
figure
n=0:100
v=0.9.^n
y=dlsim(A,B,C,D,v)
stairs(n,y)
title('System response y[n]')

figure
x0=[3 4]'; 
y=dlsim(A,B,C,D,v,x0)
stairs(n,y)
title('System response y[n]')



