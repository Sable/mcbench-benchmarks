% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%

% problem 9 
% Even and odd parts of x(t)=texp(-t)

 t=0:.1:5;
 x=t.*exp(-t);
 
 xe=0.5*t.*(exp(-t)-exp(t));
 
 xo=0.5*t.*(exp(-t)+exp(t));
 
 subplot(221);
 plot(t,x);
 
 subplot(222); 
 plot(t,xe);
 
 subplot(223);
 plot(t,xo);
 
 subplot(224);
 plot(t,xe+xo);
