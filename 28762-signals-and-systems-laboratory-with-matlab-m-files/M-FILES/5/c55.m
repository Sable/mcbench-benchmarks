%book: Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% how to plot the FS coefficients 

%x(t)=exp(-t),0<t<3 
syms t k n
x=exp(-t);

% complex exponential coefficients 
t0=0;
T=3;
w=2*pi/T;
a=(1/T)*int(x*exp(-j*k*w*t) ,t,t0,t0+T)
k1=-6:6;
ak=subs(a,k,k1);
stem(k1,abs(ak));
legend(' | a_k|, k=-6:6')
figure
stem(k1,angle(ak));
legend(' \angle a_k, k=-6:6')
figure
k2=-40:40;
ak2=subs(a,k,k2);
stem(k2,abs(ak2));
legend('|a_k|  k=-40:40')
figure
stem(k2,angle(ak2));
legend('\angle a_k  k=-40:40')


% trigonometric coefficients 
figure
a0=(1/T)*int(x,t0,t0+T)
stem(0,eval(a0)) ; 
legend('a_0')
figure
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T)
n1= 1:10;
bn=subs(b,n,n1);
stem(n1,bn);
legend('b_n')
figure
n11=1:40;
bn1=subs(b,n,n11);
stem(n11,bn1);
legend('b_n   n=1:40')
figure
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
n2=1:10;
cn=subs(c,n,n2);
stem(n2,cn);
legend('c_n')
figure
n21=1:40;
cn1=subs(c,n,n21);
stem(n21,cn1);
legend('c_n   n=1:40')



% coefficients of the cosine with phase form 
figure
A=sqrt(b^2+c^2);
n1=1:6;
An=subs(A,n,n1);
stem(n1,An);
legend('A_n  n=1:6')
figure
n11=1:40;
An1=subs(A,n,n11);
stem(n11,An1);
legend('A_n  n=1:40')
figure
thita=-atan(c/b);
n1=1:6;
thitan=subs(thita,n,n1);
stem(n1,thitan);
legend('\theta_n')
figure
thita2=atan2(-cn,bn);
stem(n1,thita2(1:6))
legend('\theta_n using atan2')
figure
n11=1:40;
thitan1=subs(thita,n,n11);
stem(n11,thitan1);
legend('\theta_n  n=1:40')
figure
thita21=atan2(-cn1,bn1);
stem(n11,thita21(1:40))
legend('\theta_n using atan2')



