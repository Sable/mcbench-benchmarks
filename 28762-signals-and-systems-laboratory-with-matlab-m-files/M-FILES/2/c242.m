% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
% causal signals 

 
 %causal
 t1=0:0.1:5;
 x1=t1.*exp(-t1);
 plot(t1,x1)
 
 %not causal
 figure
 t2=-1:0.1:5;
 x2=t2.*exp(-t2);
 plot(t2,x2)
