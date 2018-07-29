% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



%problem 5- Fourier Transform of x(t)cos(w0t) and of x(t)sin(w0t)


% F{x(t)cos(w0t)}
syms t w 
x=exp(-t)*heaviside(t);
w0=3;
Left=fourier(x*cos(w0*t),w)
X=fourier(x,w); 
Xw1=subs(X,w,w+w0);
Xw2=subs(X,w,w-w0);
Right=0.5*(Xw1+Xw2);
Right = simplify(Right) 

% F{x(t)sin(w0t)}
Left=fourier(x*sin(w0*t),w)
Right=(j/2)*(Xw1-Xw2); 
Right=simplify(Right) 
