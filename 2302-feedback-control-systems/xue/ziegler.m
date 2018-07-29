function [Gc,Kp,Ti,Td,H]=ziegler(key,vars)
Ti=[]; Td=[]; H=[];
if length(vars)==4, 
   K=vars(1); L=vars(2); 
   T=vars(3); N=vars(4); a=K*L/T; 
   if key==1,  Kp=1/a; 
   elseif key==2, Kp=0.9/a; Ti=3.33*L; 
   elseif key==3 | key==4
      Kp=1.2/a; Ti=2*L; Td=L/2; 
   end
elseif length(vars)==3, 
   K=vars(1); Tc=vars(2); N=vars(3);
   if key==1, Kp=0.5*K; 
   elseif key==2, Kp=0.4*K; Ti=0.8*Tc; 
   elseif key==3 | key==4
      Kp=0.6*K; Ti=0.5*Tc; Td=0.12*Tc; 
   end
elseif length(vars)==5, 
   K=vars(1); Tc=vars(2); 
   rb=vars(3); pb=pi*vars(4)/180; 
   N=vars(5); Kp=K*rb*cos(pb); 
   if key==2, 
      Ti=-Tc/(2*pi*tan(pb)); 
   elseif key==3 | key==4
      Ti=Tc*(1+sin(pb))/(pi*cos(pb)); 
      Td=Ti/4;
   end
end
switch key
   case 1, Gc=Kp;
   case 2, Gc=tf(Kp*[Ti,1],[Ti,0]);
   case 3
      nn=[Kp*Ti*Td*(N+1)/N, Kp*(Ti+Td/N), Kp];
      dd=Ti*[Td/N,1,0]; Gc=tf(nn,dd);
   case 4
      d0=sqrt(Ti*(Ti-4*Td)); Ti0=Ti; 
      Kp=0.5*(Ti+d0)*Kp/Ti; 
      Ti=0.5*(Ti+d0); Td=Ti0-Ti;
      Gc=tf(Kp*[Ti,1],[Ti,0]);
      nH=[(1+Kp/N)*Ti*Td, Kp*(Ti+Td/N), Kp]; 
      dH=Kp*conv([Ti,1],[Td/N,1]); H=tf(nH,dH);
end
