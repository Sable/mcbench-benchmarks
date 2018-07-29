% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% unit step sequence
 t=-5:0.1:10;
 u=heaviside(t)
 plot(t,u)
 ylim([-0.3 1.3])

 figure
 t1=-5:.1:0
 t2=0:.1:10
 u1=zeros(size(t1))
 u2=ones(size(t2));
 t=[t1 t2];
 u=[u1 u2];
 plot(t,u);
 ylim([-0.3 1.3])

 figure
 t=-5:.1:10;
u=[zeros(1,50) ones(1,101)];
 plot(t,u);
 ylim([-0.3 1.3])

 
 %u(t-t0)
 figure
  t=-5:0.1:10;
 u=heaviside(t-2)
 plot(t,u)
 ylim([-0.3 1.3])

 figure
 t1=-5:.1:2
 t2=2:.1:10
 u1=zeros(size(t1));
 u2=ones(size(t2));
 t=[t1 t2];
 u=[u1 u2];
 plot(t,u)
 ylim([-0.3 1.3])
 
 
 %symbolic use of heaviside
  syms t
 u=heaviside(t)
 diff(u,t)

