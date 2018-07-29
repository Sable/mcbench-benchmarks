function [Gc,Kp,Ti,Td,H]=gphapid(key,vars,G)
typ=vars(1); p1=vars(2); w1=vars(3); 
aa=vars(4); N=vars(5); [mm,pp]=bode(G,w1); 
mm=mm(:,:); pp=pp(:,:); H=[];
pp=pp*pi/180-2*pi; 
if typ==1
   Td=(sqrt(pp*pp*aa*aa+4*aa)-pp*aa)/(2*aa*w1); 
   Ti=aa*Td; d0=Td*Td*w1*w1; 
   Kp=1/(sqrt(1+1/(aa*aa*d0)+d0)*p1*mm);
else, p1=p1*pi/180;
   Td=(tan(p1)+sqrt(4/aa+tan(p1)^2))/(2*w1);
   Ti=aa*Td; Kp=cos(p1)/mm;
end
if key==3
   dd=Ti*[Td/N,1,0]; 
   nn=[Kp*Ti*Td*(N+1)/N, Kp*(Ti+Td/N), Kp];
   Gc=tf(nn,dd);
elseif key==4
   d0=sqrt(Ti*(Ti-4*Td)); Ti0=Ti; 
   Kp=0.5*(Ti+d0)*Kp/Ti; 
   Ti=0.5*(Ti+d0); Td=Ti0-Ti;
   Gc=tf(Kp*[Ti,1],[Ti,0]); 
   nH=[(1+Kp/N)*Ti*Td,Kp*(Ti+Td/N),Kp]; 
   dH=Kp*conv([Ti,1],[Td/N,1]);
   H=tf(nH,dH);
end
