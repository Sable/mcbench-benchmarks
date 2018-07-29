% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 	Impulse response


% H(s)=10/(s^2+2s+10)


n=10;
d=[1 2 10]
H=tf(n,d);
impulse(H)



%second way
figure
syms s t
H=10/(s^2+2*s+10);
h=ilaplace(H,t);

t=0:.1:6;
h=subs(h,t);
plot(t,h)
legend('h(t)')
