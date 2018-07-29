%book: Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% exp(-t), 0<t<3 as exponential FS 

%x(t)
t0=0;
T=3;
w=2*pi/T;
syms t
x=exp(-t);
ezplot(x,[t0 t0+T]);

%coefficients 
for k=-100:100
a(k+101)=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
end


%Approximations
figure
for k=-100:100
ex(k+101)=exp(j*k*w*t);
end
xx=sum(a.*ex);
ezplot(xx, [t0 t0+T]);
title('Approximation with 201 terms')


figure
clear a ex ; 
for k=-1:1
a(k+2)=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
end
for k=-1:1
ex(k+2)=exp(j*k*w*t);
end
xx=sum(a.*ex);
ezplot(xx,[t0 t0+T]);
title('Approximation with 3 terms')



figure
for k=-5:5
a(k+6)=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
end
for k=-5:5
ex(k+6)=exp(j*k*w*t);
end
xx=sum(a.*ex);
ezplot(xx,[t0 t0+T]);
title('Approximation with 11 terms')


figure
for k=-20:20
a(k+21)=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
end
for k=-20:20
ex(k+21)=exp(j*k*w*t);
end
xx=sum(a.*ex);
ezplot(xx, [t0 t0+T]);
title('Approximation with 41 terms')

