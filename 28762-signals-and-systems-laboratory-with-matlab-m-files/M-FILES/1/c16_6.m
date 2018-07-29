% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Dot product of two vectors 

%the vectors 
a=1:4
b=2:5

% first way
dot1=dot(a,b)

% second way
dot2=sum(a.*b)

% third way 
dot3=a*b'
