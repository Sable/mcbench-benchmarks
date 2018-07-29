% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Fourier Transfrom properties


%	Time shifting

%x(t)=cos(t)
syms t w
x=cos(t);
t0=2;
xt0=cos(t-t0);
Left=fourier(xt0,w)
X=fourier(x,w);


Right=exp(-j*w*t0)*X

