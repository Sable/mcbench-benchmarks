% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
% problem 6- Graph of 
% r(t)-r(t-1)-r(t-2)
 

 t=-2:.001:3;
 x=t.*heaviside(t)-(t-1).*heaviside(t-1)-(t-2).*heaviside(t-2);
 plot(t,x)
 ylim([-0.1 1.1]);
