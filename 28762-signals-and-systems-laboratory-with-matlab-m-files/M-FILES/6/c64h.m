% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

%Fourier Transfrom properties

%	Differentiation in time and frequency

%x(t)=exp(-3t)u(t)

% F{x'(t)}
x=exp(-3*t) *heaviside(t);
der=diff(x,t);
Left=fourier(der,w)
% jwX(w)
X=fourier(x,w);
Right=j*w*X

% F{tx(t)}
Left=fourier(t*x,w)

% jX'(w)
der=diff(X,w);
Right=j*der
