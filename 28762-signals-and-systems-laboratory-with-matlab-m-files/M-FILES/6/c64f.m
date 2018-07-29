% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Fourier Transfrom properties

%	Duality

%x(t)=exp(-t)u(t)

%F{X(t)}
x=exp(-t)*heaviside(t);
X=fourier(x)
Xt=subs(X,w,t)
Left=fourier(Xt)


%2ðx(-w)
x_w=subs(x,t,-w);
Right=2*pi*x_w
