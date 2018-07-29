% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 


% problem 3 - causality of y(t)=x(t/4)


%not causal
t1=-5:.1:-1;
x1=zeros(size(t1));
t2=-1:.1:2;
x2=ones(size(t2));
t3=2:.1:10;
x3=zeros(size(t3));
t=[t1 t2 t3];
x=[x1 x2 x3];
plot(t,x);
ylim([-0.1 1.1]);
legend('x(t)')

figure
plot(4*t,x);
ylim([-0.1 1.1]);
legend('y(t)')
