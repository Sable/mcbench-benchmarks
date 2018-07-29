%book: Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% exp(-t^2),-2<t<2 as  FS in the cosine with phase form 

%x(t)
T=4;
t0=-2;
w=2*pi/T;
syms t n
x=exp(-t^2);
ezplot(x,[t0 t0+T]);
legend('x(t)')


%trigonometric coefficients and approximation 
figure
a0=(1/T)*int(x,t,t0,t0+T) ;
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
n1=1:100;
bn =subs(b,n,n1) ;
cn=subs(c,n,n1) ;
xx=a0+sum(bn.*cos(n1*w*t))+sum(cn.*sin(n1*w*t));
ezplot(xx, [ -2 2]);
title('Approximation with 101 terms');



%coefficients of the cosine with phase form and approximation 
figure
k=1:100;
A=sqrt(bn.^2+cn.^2);
thita=atan2(-cn,bn) ;
xx=a0+sum(A.*cos(k*w*t+thita))
ezplot(xx, [-2 2])
title('Approximation with 101 terms')

