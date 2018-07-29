function [y,t,x]=ss_simu(G,x0,cc,dd,T,npoints)
G=ss(G);
[Ga,Xa]=augment(G,cc,dd,x0);
c=Ga.c; AA=expm(Ga.a*T); 
t=[0]; y=[Ga.c*Xa]; x=Xa';
for i=1:npoints
   t=[t; i*T]; Xa=AA*Xa; x=[x; Xa']; y=[y; c*Xa];
end
