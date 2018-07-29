% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	System response


%response to cos(2*pi*t)
n=10;
d=[1 2 10];
H=tf(n,d);

t=0:.1:10;
x=cos(2*pi*t);

y=lsim(H,x,t);
plot(t,y);
legend('y(t)')

figure
y=lsim(n,d,x,t);
plot(t,y);
legend('y(t)')

figure
lsim(H,x,t)



