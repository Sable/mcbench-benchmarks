% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
% Transformations of the time variable 

t=-1:.1:3;
 x=t.*exp(-t);
 plot(t,x);
 legend('x(t)')
 
 figure
 plot(-t,x);
 legend('x(-t)')
 
 figure
 a=2;
 plot((1/a)*t,x)
 legend('x(2t)') ;

 figure
  a=1/2;
 plot((1/a)*t,x)
 legend('x(1/2 t)') ;

 
 figure
 t0=2; 
 plot(t+t0,x)
 legend('x(t-2)') ;

 figure
  t0=-3; 
 plot(t+t0,x);
 legend('x(t+3)') ;

 figure
 plot(t-1,x)
 legend('x(t+ 1)') 

 figure
  plot(0.5*(t-1),x)
 legend('x(2t-1)') 

 figure
 plot(-0.5*(t-1),x)
 legend('x(1-2t)') 

