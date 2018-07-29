% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%

% problem 1- graph of
% u(t+1)-u(t-2)+u(t-4)

 t1=-5:.1:-1;
 t2=-1:.1:2;
 t3=2:.1:4;
 t4=4:.1:10;
 x1=zeros(size(t1));
 x2=ones(size(t2));
 x3=zeros(size(t3));
 x4=ones(size(t4));
 t=[t1 t2 t3 t4];
 x=[x1 x2 x3 x4];
 plot(t,x);
 ylim([-0.1 1.1]);

 figure
 t=-5:.1:10;
 x=heaviside(t+1)-heaviside(t-2)+heaviside(t-4);
 plot(t,x)
 ylim([-0.1 1.1]);


