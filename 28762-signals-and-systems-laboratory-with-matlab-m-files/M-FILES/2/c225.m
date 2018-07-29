% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Unit impulse function

%dirac(t)
 t1=-5:.1:-0.1;
 t2=0;
 t3=0.1:.1:10;
 d1=zeros(size(t1));
 d2=1;
 d3=zeros(size(t3));
 t=[t1 t2 t3];
 d=[d1 d2 d3];
 plot(t,d)

 %second way
 figure
 t=-5:.1:10;
 s=gauspuls(t)
 plot(t,s)

%  third way
 figure
 t=-5:.1:10
 d=[zeros(1,50) inf zeros(1,100) ];
 plot(t,d)
 
%  forth way
 figure
  t=-5:.1:10
 d=dirac(t);
 plot(t,d)
 
 

 %dirac(t-t0)
  t=-5:0.1:10;
 d=dirac(t+2)
 plot(t,d)
 
 
 
 %symbolic use of dirac
  syms t
 d=dirac(t)
 int(d,t,-inf,inf)



