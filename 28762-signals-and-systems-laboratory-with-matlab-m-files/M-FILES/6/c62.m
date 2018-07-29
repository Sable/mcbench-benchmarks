% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Fourier Transfrom and  inverse Fourier Transfrom  of various functions 
% the order of the operations is a little different 
%from the order that they appear on the book 


%F{exp(-t^2)}
syms t w
x=exp(-t^2);
fourier(x)

int(x*exp(-j*w*t),t,-inf,inf)


%F^-1{1/(1+j*w)}
X=1/(1+j*w);
ifourier(X)

X=1/(1+j*w);
ifourier(X,t)

syms n
X=1/(1+j*w);
ifourier(X,n)


%F{exp(-t)*u(t)}
syms t w
x=exp(-t)*heaviside(t);
X=fourier(x,w)


%F{1}
x=1;
fourier(x,w)
syms s
fourier(x,s)
fourier(x)

