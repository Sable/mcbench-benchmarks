% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%

% problem 2- graph of
% u(t+1)*u(t-1)


 t1=-5:.1:1;
 t2=1:.1:10;
 x1=zeros(size(t1));
 x2=ones(size(t2));
 t=[t1 t2];
 x=[x1 x2];
 plot(t,x);
 ylim([-0.1 1.1]);
 
 figure
 t=-5:.1:10;
 x=heaviside(t+1).*heaviside(t-1) ;
 plot(t,x); 
 ylim([-0.1 1.1]);
