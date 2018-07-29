% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% 
% problem 10 
% Transformations of  x(t)=t*cos(2*pi*t)

 t=0:0.01:5;
 x=t.*cos(2*pi*t); 
 plot(t,x);
 legend('x(t)') ;
 
 figure
 plot(-t,x)
 legend('x(-t)') ;
 
 figure
 plot(5*t,x)
 legend('x(t/5)') ;
 
 figure
 plot((1/3)*(-1+t),x) 
 legend('x(1+3t)') ;
 
 figure
 plot(-(1/3)*(1+t),x)
 legend('x(-1-3t)') ;

