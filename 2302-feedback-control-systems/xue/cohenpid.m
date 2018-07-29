function [Gc,Kp,Ti,Td,H]=cohenpid(key,vars)
K=vars(1); L=vars(2); T=vars(3); N=vars(4); 
a=K*L/T; tau=L/(L+T); H=[];
if key==1,  
   Kp=(1+0.35*tau/(1-tau))/a; Gc=tf(Kp,1);
elseif key==2, 
   Kp=0.9*(1+0.92*tau/(1-tau))/a; 
   Ti=(3.3-3*tau)*L/(1+1.2*tau);
   Gc=tf(Kp*[Ti,1],[Ti,0]);
elseif key==3 | key==4
   Kp=1.35*(1+0.18*tau/(1-tau))/a; 
   Ti=(2.5-2*tau)*L/(1-0.39*tau); 
   Td=0.37*(1-tau)*L/(1-0.81*tau); 
   if key==3
      nn=[Kp*Ti*Td*(N+1)/N,Kp*(Ti+Td/N),Kp];
      dd=Ti*[Td/N,1,0]; Gc=tf(nn,dd);
   elseif key==4
      d0=sqrt(Ti*(Ti-4*Td)); Ti0=Ti; 
      Kp=0.5*(Ti+d0)*Kp/Ti; 
      Ti=0.5*(Ti+d0); Td=Ti0-Ti;
      nH=[(1+Kp/N)*Ti*Td, Kp*(Ti+Td/N), Kp]; 
      dH=Kp*conv([Ti,1],[Td/N,1]);
      H=tf(nH,dH); Gc=tf(Kp*[Ti,1],[Ti,0]);
   end
elseif key==5
   Kp=1.24*(1+0.13*tau/(1-tau))/a; 
   Td=(0.27-0.36*tau)*L/(1-0.87*tau); Ti=[];
   Gc=tf(Kp*[Td*(N+1)/N,1],[Td/N,1]);
end
