% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 11 - Computes the linear convolution of two sequences 


% b)
x1=1:4;
x2=7:-1:1;
y=linconv(x1,x2)

% c)
y=conv(x1,x2)
