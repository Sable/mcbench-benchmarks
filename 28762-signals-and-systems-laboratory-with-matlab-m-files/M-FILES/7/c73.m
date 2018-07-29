% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Parseval's Theorem

%x[n]=0.6^n u[n]
syms n w
a=0.6;
x=a^n;
E=symsum(abs(x)^2,n,0,inf);
E=eval(E)


X=1/(1-a*exp(-j*w));
Esd=abs(X)^2;
E=1/(2*pi)*int(Esd,w,-pi,pi);
E=eval(E)
