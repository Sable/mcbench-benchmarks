% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
%rectangular pT(t) 
 t=-5:.1:10;
 u1=heaviside(t+2);
 u2=heaviside(t-2);
 p=u1-u2;
 plot(t,p)
 ylim([-0.3 1.3])

%  second way
 figure
 t1=-5:.1:-2;
 t2=-2:.1:2;
 t3=2:.1:10;
 p1=zeros(size(t1));
 p2=ones(size(t2));
 p3=zeros(size(t3));
 t=[t1 t2 t3];
 p=[p1 p2 p3];
 plot(t,p);
 ylim([-0.3 1.3]);

%  third way
 figure
 t=-5:.1:10;
 s=rectpuls(t,4);
 plot(t,s)
 ylim([-.3 1.3])
 
 

 % pT(t-t0) 
 figure
 t=-5:.1:10
 u1=heaviside(t)
 u2=heaviside(t-4)
 p=u1-u2
 plot(t,p)
 ylim([-0.3 1.3])
