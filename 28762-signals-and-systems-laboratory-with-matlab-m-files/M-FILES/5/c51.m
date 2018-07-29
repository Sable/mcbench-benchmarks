%book: Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% orthogonality of complex exponential signals  

syms t T
w=2*pi/T;
x=exp(j*3*w*t);
yc=exp(-j*5*w*t);
I= int(x*yc,t,0,T)
yc=exp(-j*3*w*t);
I= int(x*yc,t,0,T)

