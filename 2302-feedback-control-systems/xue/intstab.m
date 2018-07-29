function [V,cc]=intstab(G,Gc,H)
G1=zpk(minreal(feedback(Gc*G,H)));
G2=zpk(Gc*G*H);
V=0; cc=[];
vv=G1.p{1}; ii=find(real(vv)>=0); 
if length(ii)>0, V=1; cc=vv(ii);
else
   z=G2.z{1}; p=G2.p{1};
   for i=1:length(z), 
      ii=find(abs(z(i)-p)<1000*eps);
      if length(ii)>0
         if real(z(i))>=0, 
            V=2; cc=[cc,z(i)]; break; 
end, end, end, end
