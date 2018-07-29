% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
% problem 7 - Graph of 
% r(t)-r(t-1)+r(t-2)-2r(t-3)+r(t-5)

 t=-1:.001:10;
 
 x=t.*heaviside(t)-(t-1).*heaviside(t-1)+(t-2).*heaviside(t-2)-2*(t-3).*heaviside(t-3)+(t-5).*heaviside(t-5);
 
 plot(t,x); 
 
 grid;
