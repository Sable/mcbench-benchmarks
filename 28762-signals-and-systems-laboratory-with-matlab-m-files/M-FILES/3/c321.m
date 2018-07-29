% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% Causality

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


%not causal
figure
plot(t-1,x)
ylim([-0.1 1.1]);
legend('y_1(t)')


% causal
figure
plot(t+1,x)
ylim([-0.1 1.1]);
legend('y_2(t)')
