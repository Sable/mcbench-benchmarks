% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Problem 2-  Frequency Response  Graph 
%                                         
% 
% 
%             8w^2+2jw+9 
%      H(jw)=---------------
%             6(jw)^2-10 


num=[8/j^2 2 9];
den=[6/j 0 -10];
freqs(num,den)
