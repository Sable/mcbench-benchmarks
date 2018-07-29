% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% problem 1 -convolution of x(t) and h(t)

 t=0:.01:10;
 h=t;
 x=0.8.^t;
 y=conv(x,h)*0.01;
 ty=0:0.01:20;
 plot(ty,y);
 legend('Response of the system');
