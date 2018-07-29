% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

%Symmetry 

%x(t)=exp(-2t)u(t)

% X(w)
syms t w
x=exp(-2*t) *heaviside(t);
X=fourier(x,w);

% Re{X(w)}+jIm{X(w)}
Xre=real(X);
Xim=imag(X);
Right=Xre+j*Xim;


% Re{X(-w)}
X_w=subs(X,w,-w);
Left=real(X_w)
% Re{X(w)}
Right=real(X)

% Im{X(-w)}
Left=imag(X_w);
% -Im{X(w)}
Right=-imag(X);
A=Left-Right;
A=subs(A,conj(w),w);
simplify(A)


% X(-w)
X_w=subs(X,w,-w)
% conj(X(w))
Xc=conj(X);
Xc=subs(Xc,conj(w),w)
