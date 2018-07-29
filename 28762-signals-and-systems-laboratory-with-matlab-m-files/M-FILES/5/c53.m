%book: Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% exp(-t), 0<t<3 as trigonometric FS 

%x(t)
T=3;
t0=0;
w=2*pi/T;
syms t
x=exp(-t);

%coefficients 
a0=(1/T)*int(x,t,t0,t0+T);
for n=1:200
b(n)=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
end
for n=1:200
c(n)=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
end

%Approximations
k=1:200;
xx=a0+sum(b.*cos(k*w*t))+sum(c.*sin(k*w*t))
ezplot(xx, [t0 t0+T]); 
title('Approximation with 201 terms')


figure
clear b c
for n=1:5
b(n)=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c(n)=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
end
k=1:5;
xx=a0+sum(b.*cos(k*w*t))+sum(c.*sin(k*w*t))
ezplot(xx, [t0 t0+T]); 
title('Approximation with 6 terms')



figure
for n=1:20
b(n)=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c(n)=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
end
k=1:20;
xx=a0+sum(b.*cos(k*w*t)) +sum(c.*sin(k*w*t));
ezplot(xx, [t0 t0+T]); 
title('Approximation with 21 terms')




