% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%

% problem 4 - graph of 
%t*sin(2*pi*t)[u(t)-u(t-3)]



 t=0:.01:3;
 x=t.*sin(2*pi*t);
 plot(t,x)

 figure
  t=-5:.01:10;
 x=t.*sin(2*pi*t).*(heaviside(t)-heaviside(t-3));
 plot(t,x)
