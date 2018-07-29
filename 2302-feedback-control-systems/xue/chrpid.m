function [Gc,Kp,Ti,Td,H]=chrpid(key,typ,vars)
K=vars(1); L=vars(2); T=vars(3); N=vars(4); 
a=K*L/T; ovshoot=vars(5); H=[];
if typ==1, TT=T; else TT=L; typ=2;  end
if ovshoot==0, 
   KK=[0.3,0.35,1.2,0.6, 1,  0.5;
       0.3,0.6, 4,  0.95,2.4,0.42];
else, 
   KK=[0.7,0.6,1,  0.95,1.4,0.47;
       0.7,0.7,2.3,1.2, 2,  0.42]; 
end
if key==1,  
   Kp=KK(typ,1)/a; Gc=tf(Kp,1);
elseif key==2, 
   Kp=KK(typ,2)/a; Ti=KK(typ,3)*TT; 
   Gc=tf(Kp*[Ti,1],[Ti,0]);
else
   Kp=KK(typ,4)/a; Ti=KK(typ,5)*TT; 
   Td=KK(typ,6)*L; 
   if key==3
      nn=[Kp*Ti*Td*(N+1)/N, Kp*(Ti+Td/N), Kp];
      dd=Ti*[Td/N,1,0]; Gc=tf(nn,dd);
   elseif key==4
      d0=sqrt(Ti*(Ti-4*Td)); Ti0=Ti; 
      Kp=0.5*(Ti+d0)*Kp/Ti; 
      Ti=0.5*(Ti+d0); Td=Ti0-Ti;
      Gc=tf(Kp*[Ti,1],[Ti,0]); 
      nH=[(1+Kp/N)*Ti*Td, Kp*(Ti+Td/N), Kp]; 
      dH=Kp*conv([Ti,1],[Td/N,1]); 
      Gc=tf(nn,dd); H=tf(nH,dH);
   end
end
