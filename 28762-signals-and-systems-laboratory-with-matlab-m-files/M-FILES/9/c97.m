% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 
% 
% Convolution in time and in complex frequency 
% 



%Convolution in the time-domain 
syms t s
x1=heaviside(t)-heaviside(t-5);
x2=heaviside(t)-heaviside(t-10);
X1=laplace(x1,s);
X2=laplace(x2,s);
R=ilaplace(X1*X2,t);
ezplot(R,[0 20]);
title('L^-^1[X_1(s)X_2(s)]')

figure
t1=0:.01:5;
t2=5.01:.01:10;
x1=[ones(size(t1)) zeros(size(t2))];
x2=ones(size([t1 t2]));
y=conv(x1,x2)*.01;
plot(0:.01:20,y);
title(' Convolution ')
ylim([-.5 5.5])




% Convolution in the complex frequency domain
syms t s
X1=1/(s^2+4);
X2=8/(s-3);
x1=ilaplace(X1,t);
x2=ilaplace(X2,t);
con=(2*pi*j)*laplace(x1*x2)

 