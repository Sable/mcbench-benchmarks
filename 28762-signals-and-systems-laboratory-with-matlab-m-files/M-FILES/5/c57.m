%book : Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% FS of periodic signals 

%x(t)= 1, 0<t<1   , T=2 
%     -1, 1<t<2  

%x(t), 0<t<5T
t1=0:.01:1;
t2=1.01:.01:2;
x1=ones(size(t1));
x2=-ones(size(t2));
x=[x1 x2];
xp=repmat(x,1,5);
t=linspace(0,10,length(xp));
plot(t,xp)

%x(t), 0<t<T
figure
syms t
x=heaviside(t)-2*heaviside(t-1);
ezplot(x,[0 2]); 

%exponential FS 
figure
k=-2:2;
t0 =0; 
T=2;
w=2*pi/T; 
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T)
xx=sum(a.*exp(j*k*w*t))
ezplot(xx,[0 10])
title('approximation with 5 terms')
figure
k=-5:5;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[0 10])
title('approximation with 11 terms')
figure
k=-10:10;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[0 10])
title('approximation with 21 terms')
figure
k=-30:30;
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T);
xx=sum(a.*exp(j*k*w*t));
ezplot(xx,[0 10])
title('approximation with 61 terms')


%trigonometric FS
figure
a0=(1/T)*int(x,t0,t0+T);
n=1:2;
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
xx=a0+sum(b.*cos(n*w*t))+sum(c.*sin(n*w*t));
ezplot(xx,[0 10])
title('approximation with 3 terms')
figure
n=1:5;
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
xx=a0+sum(b.*cos(n*w*t))+sum(c.*sin(n*w*t));
ezplot(xx,[0 10])
title(' approximation with 6 terms')
figure
n=1:40;
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
xx=a0+sum(b.*cos(n*w*t))+sum(c.*sin(n*w*t));
ezplot(xx,[0 10])
title('approximation with 41 terms')


%FS in cosine with phase form
figure
for n=1:2
A(n)=sqrt(b(n)^2+c(n)^2);
thita(n)=atan2(-eval(c(n)),eval(b(n)));
end
k=1:2;
xx=a0+sum(A.*cos(k*w*t+thita))
ezplot(xx,[0 10])	
title('approximation with 3 terms')
figure
for n=1:5
A(n)=sqrt(b(n)^2+c(n)^2);
thita(n)=atan2(-eval(c(n)),eval(b(n)));
end
k=1:5;
xx=a0+sum(A.*cos(k*w*t+thita));
ezplot(xx,[0 10])
title('approximation with 6 terms')
figure
for n=1:40
A(n)=sqrt(b(n)^2+c(n)^2);
thita(n)=atan2(-eval(c(n)),eval(b(n)));
end
k=1:40;
xx=a0+sum(A.*cos(k*w*t+thita));
ezplot(xx,[0 10])
title('approximation with 41 terms')

