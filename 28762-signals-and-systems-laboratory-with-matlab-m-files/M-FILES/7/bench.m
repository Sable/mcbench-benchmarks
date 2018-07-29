% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 9 - This script measures the execution time of the functions circonv2.m and circonv3.m 

n1=0:10e3;
x1=1.01.^n1;
n2=0:9e2;
x2=cos(n2);
disp ('circonv2')
tic
y=circonv2(x1,x2);
toc
disp ('circonv3')
tic
y=circonv3(x1,x2);
toc
