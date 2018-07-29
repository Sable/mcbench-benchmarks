% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Relationship between FS coefficients 

%b(k)=a(k)+a(-k)
%c(k)=j[a(k)-a(-k)]
syms t ; 
x=exp(-t);
t0=0;   
T=5;   
w=2*pi/T;  
k=-6:6; 
n=1:6 ; 
b=(2/T)*int(x*cos(n*w*t),t,t0,t0+T);
b=eval(b)
c=(2/T)*int(x*sin(n*w*t),t,t0,t0+T);
c=eval(c)
a=(1/T)*int(x*exp(-j*k*w*t), t,t0,t0+T);
a=eval(a);
for i=1:6
bb(7-i)=a(14-i)+a(i);
cc(7-i)=j*(a(14-i)-a(i));
end
bb
cc 



% a(k)=0.5[b(k)-jc(k)]
an=(1/2)*(b-j*c)
ak(1:6)=a(8:13)
