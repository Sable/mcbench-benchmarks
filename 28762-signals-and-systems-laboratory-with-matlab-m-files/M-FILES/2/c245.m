% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%

%  stochastic  signals

 t=0:.1:10;
 x1=randn(size(t));
 plot(t,x1);

 figure
  t=0:.1:10;
 x2=randn(size(t));
 plot(t,x2);
 
 figure
 x=randn(20,1);
 stem(x);
