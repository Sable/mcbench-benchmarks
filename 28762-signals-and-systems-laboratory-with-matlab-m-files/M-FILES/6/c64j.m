% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

%Fourier Transfrom properties

%	even and odd parts of x(t)

%x(t)=exp(-t)u(t)


% F{x-even}
syms t w
x=exp(-t) *heaviside(t);
x_t=subs(x,t,-t);
xe=0.5*(x+x_t)
xo=0.5*(x-x_t);
xe+xo
X=fourier(x,w)
Xe=fourier(xe,w)
% Re{X(w)}
Xre=real(X)
Xre=subs(Xre, conj(w),w)

dif= Xe-Xre
simplify(dif)


% F{x-odd}
Xo=fourier(xo,w)
% Im{X(w)}
Xim=imag(X)
Xim=subs(Xim,conj(w),w)

dif=Xo-j*Xim ;
simplify(dif)

