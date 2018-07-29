% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%   Transfer Function in zero/pole/gain form  
% 


num=[2 1];
den=[1 3 2];
H=tf(num,den);
H2=zpk(H)



num=[2 1];
den=[1 3 2];
[z,p,k]=tf2zp(num,den)


[n,d]=zp2tf(z,p,k)
