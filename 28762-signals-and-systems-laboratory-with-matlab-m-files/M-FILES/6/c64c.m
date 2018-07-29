% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Fourier Transfrom properties

%	Frequency shifting 


%x(t)=t^3, w0=3
syms t w
x=t^3;
w0=3;
Le=exp(j*w0*t)*x;
Left=fourier(Le,w)

X=fourier(x,w)
Right=subs(X,w,w-w0)
