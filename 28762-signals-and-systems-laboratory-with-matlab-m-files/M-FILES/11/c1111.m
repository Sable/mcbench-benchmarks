% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	System response 


% Conversion between continuous time and discrete time systems 


%continious to discrete 
n=[1 10];
d=[1 0];
Hs=tf(n,d)

Ts=0.2;
Hz=c2d(Hs,Ts,'zoh')



%discrete to continious
num= [1 1];
den=[1 -1];
Ts=0.2; 
Hz=tf(num,den,Ts)

Hs=d2c(Hz,'zoh')
