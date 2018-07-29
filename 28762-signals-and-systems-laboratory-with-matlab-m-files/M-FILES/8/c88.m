% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%    System Response to discrete time sinusoidal inputs 


w0=4;
Hw0=(3+exp(-j*w0))/(2+4*exp(-j*w0));
mag=abs(Hw0)
phas=angle(Hw0)

syms n
y=2*mag*cos(w0*n+pi/3+ phas)

n=-10:10;
x=2*cos(w0*n+pi/3);
y=subs(y,n)
plot(n,y,':o',n,x,':+')
legend('y[n]','x[n]')
