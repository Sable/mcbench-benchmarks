% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 1- Stability of system with Transfer Function H(s)= H1(s)/H2(s)


num1=[1 1];
num2=[1 2];
numH2=conv(num1,num2);

den1=[1 2j];
den2=[1 -2j];
den3=[1 3];
den12=conv(den1,den2);
denH2=conv(den12,den3);

numH1=[2 0 1];
numH=conv(numH1,denH2);

denH1=[1 3 3 1];
denH=conv(denH1,numH2);

H=tf(numH,denH)

poles=pole(H)


pzmap(H)
