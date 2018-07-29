% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
% problem 8- periodic signal 
% in one period x[n]=[0.5,1,1]
 


 x=[0.5 1 1];
 
 xp=repmat(x,1,40);
 
 stem(10:length(xp)+9,xp);
