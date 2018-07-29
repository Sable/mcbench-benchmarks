%book: Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% FS of complex signals 


%x(t)=t^2 +j*2*t
syms t 
t0=0;
T=10;
w=2*pi/T;
x= t^2 +j*2*t;
subplot(211);
ezplot(real(x),[t0 T]);
title ('Real part of x(t)');
subplot(212);
ezplot(imag(x),[t0 T]);
title ('Imaginary part of x(t)');

%complex exponential FS
figure %approximation
for k=-2:2 
a(k+3)=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
ex(k+3)=exp(j*k*w*t);
end
xx=sum(a.*ex);
subplot(211);
ezplot(real(xx),[t0 T]);
title ('Real part of xx(t)');
subplot(212);
ezplot(imag(xx),[t0 T]);
title ('Imaginary part of xx(t)');

figure %approximation
for k=-20:20
a(k+21)=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
ex(k+21)=exp(j*k*w*t);
end
xx=sum(a.*ex);
subplot(211);
ezplot(real(xx),[t0 T]);
title ('Real part of xx(t)');
subplot(212);
ezplot(imag(xx),[t0 T]);
title ('Imaginary part of xx(t)');

figure %coefficients
a1=eval(a)
subplot(211);
stem(-20:20,abs(a1));
legend ('|a_k| ,k=-20:20')
subplot(212);
stem(-20:20,angle(a1));
legend ('\angle a_k ,k=-20:20')



%trigonometric FS
figure %approximation
a0=(1/T)*int(x,t,t0,t0+T);
for n=1:4
b(n)=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c(n)=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
end
k=1:4;
xx=a0+sum(b.*cos(k*w*t))+sum(c.*sin(k*w*t))
subplot(211); 
ezplot(real(xx), [t0 T]);
title('Real part of xx(t)');
subplot(212); 
ezplot(imag(xx), [t0 T]);
title('Imaginary part of xx(t)');

a0
b
c

figure %approximation
a0=(1/T)*int(x,t,t0,t0+T);
for n=1:20
b(n)=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c(n)=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
end
k=1:20;
xx=a0+sum(b.*cos(k*w*t))+sum(c.*sin(k*w*t))
subplot(211); 
ezplot(real(xx), [t0 T]);
title('Real part of xx(t)');
subplot(212); 
ezplot(imag(xx), [t0 T]);
title('Imaginary part of xx(t)');

