function [Gc,Kp,Ti,Td,H]=imcpid(key,vars)
K=vars(1); L=vars(2); T=vars(3); N=vars(4); 
a=K*L/T; Tf=vars(5); H=[];
if key==2, 
   Kp=T/(K*(L+Tf)); Ti=T; 
   Gc=tf(Kp*[Ti,1],[Ti,0]);
else
   Kp=(L/2+T)/(K*(L+Tf)); 
   Ti=T+L/2; Td=L*T/(L+2*T); 
   if key==3
      nn=[Kp*Ti*Td*(N+1)/N,Kp*(Ti+Td/N),Kp];
      dd=Ti*[Td/N,1,0]; Gc=tf(nn,dd);
   elseif key==4
      d0=sqrt(Ti*(Ti-4*Td)); Ti0=Ti; 
      Kp=0.5*(Ti+d0)*Kp/Ti; 
      Ti=0.5*(Ti+d0); Td=Ti0-Ti;
      Gc=tf(Kp*[Ti,1],[Ti,0]);
      nH=[(1+Kp/N)*Ti*Td, Kp*(Ti+Td/N), Kp]; 
      dH=Kp*conv([Ti,1],[Td/N,1]);
      H=tf(nH,dH);   
   end
end
