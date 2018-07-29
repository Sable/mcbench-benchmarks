% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% stability 

 syms n
 h=1/(2^n)
 symsum(abs(h),n,0,inf)
