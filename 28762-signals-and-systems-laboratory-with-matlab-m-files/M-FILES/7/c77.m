% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Circular shift of a sequence 
x=[.1,.2,.3,.4,.5,.6,.7,.8]
N=8;
m=2;
x'
n=0;
p=mod((n-m),N)
xc(n+1)=x(p+1);
xcm=xc'

n=1;
p=mod((n-m),N)
xc(n+1)=x(p+1);
xcm=xc'

n=2;
p=mod((n-m),N)
xc(n+1)=x(p+1);
xcm=xc'
n=3;
p=mod((n-m),N)
xc(n+1)=x(p+1);
xcm=xc'
n=4;
p=mod((n-m),N)
xc(n+1)=x(p+1);
xcm=xc'
for n=5:N-1
p=mod((n-m),N);
xc(n+1)=x(p+1);
end
xcm=xc'



%second way 
m=2;
xcm=circshift(x',m)


%Graphs 
stem(0:N-1,x)
xlim([-.5 N-1+.5]);
ylim([-.1 1]);
legend('x[n]')

figure
m=1;
xcm1=circshift(x',m);
stem(0:N-1,xcm1);
xlim([-.5   N-1+.5]);
ylim([-.1 1]);
legend('x_c_,_m[n], m=1')

figure
m=2;
xcm2=circshift(x',m);
stem(0:N-1,xcm2);
xlim([-.5    N-1+.5]);
ylim([-.1 1]);
legend('x_c_,_m[n], m=2')

figure
m=4;
xcm4=circshift(x',m);
stem(0:N-1,xcm4);
xlim([-.5     N-1+.5]);
ylim([-.1 1]);
legend('x_c_,_m[n], m=4')




