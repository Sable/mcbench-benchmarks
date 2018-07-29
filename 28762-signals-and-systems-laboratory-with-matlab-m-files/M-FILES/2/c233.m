% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
%Real valued exponential sequence a^n
n=-3:5

a1=0.8;
x1=a1.^n;
stem(n,x1);

figure
a2=1.2;
x2=a2.^n;
stem(n,x2);
