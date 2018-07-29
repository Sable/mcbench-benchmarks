function [Gc,Kp,Ti,Td,H]=optPID(key,typ,vars)
k=vars(1); L=vars(2); T=vars(3); N=vars(4); 
Td=[];H=1;
if length(vars)==5, iC=vars(5); tt=0;  
else, 
   Kc=vars(5); Tc=vars(6); kappa=vars(7); tt=1; 
end
if tt==0
   if key==2
PIDtab=[0.980, 0.712, 0.569, 1.072, 0.786, 0.628;
       -0.892,-0.921,-0.951,-0.560,-0.559,-0.583;
        0.690, 0.968, 1.023, 0.648, 0.883, 1.007;
       -0.155,-0.247,-0.179,-0.114,-0.158,-0.167];
   elseif key==3
PIDtab=[1.048, 1.042, 0.968, 1.154, 1.142, 1.061; 
       -0.897,-0.897,-0.904,-0.567,-0.579,-0.583;
        1.195, 0.987, 0.977, 1.047, 0.919, 0.892;
       -0.368,-0.238,-0.253,-0.220,-0.172,-0.165;
        0.489, 0.385, 0.316, 0.490, 0.384, 0.315;
        0.888, 0.906, 0.892, 0.708, 0.839, 0.832];
   elseif key==4
PIDtab=[1.260, 1.053, 0.942, 1.295, 1.120, 1.001;
       -0.887,-0.930,-0.933,-0.619,-0.625,-0.624;
        0.701, 0.736, 0.770, 0.661, 0.720, 0.754;
       -0.147,-0.126,-0.130,-0.110,-0.114,-0.116;
        0.375, 0.349, 0.308, 0.378, 0.350, 0.308;
        0.886, 0.907, 0.897, 0.756, 0.811, 0.813];
   end
   ii=0; if (L/T>1) ii=3; end; tt=L/T; 
   a1=PIDtab(1,ii+iC); b1=PIDtab(2,ii+iC); 
   a2=PIDtab(3,ii+iC); b2=PIDtab(4,ii+iC); 
   Kp=a1/k*tt^b1; Ti=T/(a2+b2*tt); 
   if key==3| key==4
      a3=PIDtab(5,ii+iC); b3=PIDtab(6,ii+iC); 
      Td=a3*T*tt^b3;
   end
else
   if key==2,
      Kp=0.361*Kc; Ti=0.083*(1.935*kappa+1)*Tc; 
   elseif key==3,
      Kp=0.509*Kc; Td=0.125*Tc;
      Ti=0.051*(3.302*kappa+1)*Tc;
   elseif key==4,
      Kp=(4.437*kappa-1.587)...
         /(8.024*kappa-1.435)*Kc; 
      Ti=0.037*(5.89*kappa+1)*Tc;  
      Td=0.112*Tc;
   end
end
if key==2, Gc=tf(Kp*[Ti,1],[Ti,0]);
elseif key==3
   nn=[Kp*Ti*Td*(N+1)/N, Kp*(Ti+Td/N), Kp];
   dd=Ti*[Td/N,1,0]; Gc=tf(nn,dd);
elseif key==4
   Gc=tf(Kp*[Ti,1],[Ti,0]);
   nH=[(1+Kp/N)*Ti*Td, Kp*(Ti+Td/N), Kp];
   dH=Kp*conv([Ti,1],[Td/N,1]); H=tf(nH,dH);
end
