% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% System response according to the frequency response 
                                 

num=[5 2];
den=[2 3 4];
t=0:.1:10;
x=t.*exp(-t);
y=lsim(num,den,x,t);
plot(t,y);
title('System response y(t)')

figure
lsim(num,den,x,t);



%second example 
figure
num=[2  0 7];
den=[3 2 1];
t=0:.1:20;
x=1./(t+1);
y=lsim(num,den,x,t);
plot(t,y) ;
title('System response y(t)')

figure
lsim(num,den,x,t);

