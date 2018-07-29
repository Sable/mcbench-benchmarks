function [Gc,tau]=minsens(G,W,options)
t1=options(1); t2=options(2);
G=tf(G); W=tf(W); num=G.num{1}; den=G.den{1};
ii=find(abs(num>eps)); 
num=num(ii(1):length(num));
k=length(den)-length(num); 
zr=roots(num); norms=[]; JJ=[];
tt=logspace(log10(t1),log10(t2),10); 
if ~any(real(zr)>=0)
   for i=1:length(tt)
      Jden=1; 
      for j=1:k, 
         Jden=conv(Jden,[tt(i),1]); 
      end
      nn=Jden-[zeros(1,k),1]; JJ=[JJ; Jden];
      g1=tf(nn,Jden); g=ss(g1*W);
      norms=[norms,normhinf(g.a,g.b,g.c,g.d)];
   end
end
norms, key=input('Select a number n=> ');
tau=tt(key); Qnum=den; Qden=JJ(key,:); 
nn=JJ(key,:)-[zeros(1,k),1]; 
g1=tf(Qnum,Qden); g2=tf(JJ(key,:),nn);
Gc=minreal(g1*g2);
