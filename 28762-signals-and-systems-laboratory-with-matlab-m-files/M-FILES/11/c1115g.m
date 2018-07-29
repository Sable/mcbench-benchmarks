% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 7- Discrete time system


% a) Stability 
num=[8 10 -6];
den=[1 2 -1 -2];
zplane(num,den)

% b) in zero/pole/gain form
Ts=0.1;
H=tf(num,den,Ts);
H=zpk(H)

% c)in partial fraction form
[R,P,K]=residue(num,den)
