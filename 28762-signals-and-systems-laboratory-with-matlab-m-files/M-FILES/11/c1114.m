% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	State Space representation  



% state space model
A=[0.1 1 ;-1.5 -2];
B=[1; 0];
C=[1 2];
D=0.1;
sys=ss(A,B,C,D)

%extraction of the model matrices 
[A,B,C,D]=ssdata(sys)



%system response to v(t)=20t*exp(-t);
t=0:.1:10;
v=20*t.*exp(-t);
y=lsim(sys,v,t);
plot(t,y);
title('Output signal y(t)');


figure
lsim(A,B,C,D,v,t)


figure
x0=[10;20];
lsim(sys,v,t,x0)


%impulse response 
figure
h=impulse(sys,t);
plot(t,h)
title('Impulse response h(t)');


%State evolution
figure
[h,t,x]=impulse(sys);
plot(t,x(:,1),t,x(:,2),':')
legend('x_1(t)','x_2(t)');
title('State evolution')


%step response 
figure
s=step(sys,t);
plot(t,s)
title('Step response ');


% Initial state response
figure
y=initial(sys,x0,t)
plot(t,y)
title('Initial state response');






