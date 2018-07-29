% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 
% 
% problem 3- Inverse Laplace Transform computation 

syms s t
Y=1/s +2/(s+4)+1/(s+5) ; 
y=ilaplace(Y,t)
