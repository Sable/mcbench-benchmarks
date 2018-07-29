% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 2- Transfer Function of systems with mixed interconnection


num1=[1 0];
den1=[1 4];
H1=tf(num1,den1);

num2=[1 0];
den2=[1 0 4];
H2=tf(num2,den2);

num3=[1 0 0];
den3=[1 0 4];
H3=tf(num3,den3);

H12=parallel(H1,H2);

H=series(H12,H3)
