% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Problem 11-  System response to discrete time sinusoidal input 


syms n
w0=2;
Hw0=(3*j*w0+2)/(w0+1);

mag=abs(Hw0);
phas=angle(Hw0);

y=3*mag*sin(w0*n+1+ phas);

n=0:50;
y=subs(y,n);
stem(n,y);
legend('y[n]');
