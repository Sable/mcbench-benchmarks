% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



%problem 7- convolution in the time domain  

syms x t r w
y=x*exp(-x) *heaviside(x);
Y=fourier(y,w)
Y1= j*w*Y;
Y0=subs(Y,w,0)
Y2=(1/(j*w))*Y+pi *Y0*dirac(w);
Convol=ifourier (Y1*Y2,t)
ezplot(Convol, [0 10])
legend('Convolution Result ')
