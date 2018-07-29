% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Unit ramp function


% ramp r(t)
 t=-5:0.1:10;
 r=t.*heaviside(t);
 plot(t,r)

%  second way
 figure
 t1=-5:.1:-0.1;
 t2=0:.1:10;
 r1=zeros(size(t1));
 r2 = t2;
 t=[t1 t2];
 r=[r1 r2];
 plot(t,r)

 
 
 
 %r(t-t0)
 figure
 t=-5:.1:10;
 r=(t-1).*heaviside(t-1)
 plot(t,r)
