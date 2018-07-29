% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Fourier Transfrom properties

%	Scaling in time and frequency

%x(t)=u(t+1)-u(t-1)
syms t w
b=3;
x=heaviside(t+1)-heaviside(t-1);
ezplot(x,[-2 2]);
legend('x(t)');
X=fourier(x,w);
ezplot(X,[-40 40]);
legend('X(\omega)')
xlabel('\Omega')

%F{x(bt)}
figure
xb=subs(x,t,b*t);
ezplot(xb, [-2 2]);
legend('x(bt), b=3');
Xb=fourier(xb,w);
ezplot(Xb, [-40 40])
legend('F(x(bt))')
xlabel('\Omega')

%1/|b|*X(w/b)
figure
Ri=subs(X,w,w/b);
Right=(1/abs(b))*Ri;
ezplot(Right,[-40 40]);
legend('(1/|b|)*X(\omega/b)')
xlabel('\Omega')

