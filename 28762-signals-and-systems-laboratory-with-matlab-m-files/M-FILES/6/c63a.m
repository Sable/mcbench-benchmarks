% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Fourier Transfrom pairs  

syms t w  w0 t0

x=dirac(t);
fourier(x,w)

fourier(1,w)

X=1/(j*w)+pi*dirac(w);
ifourier(X,t)

x=dirac(t-t0);
fourier(x,w)

X=2*pi*dirac(w-w0);
ifourier(X,t)

X=pi*(dirac(w-w0)+dirac(w+w0));
ifourier(X,t)

X=(pi/j)* (dirac(w-w0)-dirac(w+w0));
x= ifourier(X,t)

a=8;
x=exp(-a*t) *heaviside(t);
X= fourier(x,w)

x=t*exp(-a*t) *heaviside(t);
fourier(x,w)

n=4;
X=1/(j*w+a)^n;
ifourier(X,t)
