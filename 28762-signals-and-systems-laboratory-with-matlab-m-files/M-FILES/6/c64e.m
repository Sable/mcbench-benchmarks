% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Fourier Transfrom properties

%	Time reversal

%x(t)=t*u(t)

%X(-w)
x=t*heaviside(t);
X=fourier(x,w) ;
Right=subs(X,w,-w)

%x(-t)
x_t=subs(x,t,-t);
Left=fourier(x_t,w)
