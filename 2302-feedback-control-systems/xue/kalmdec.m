function [Gk,T,K]=kalmdec(G)
G=ss(G); A=G.a; B=G.b; C=G.c;
[Ac,Bc,Cc,Tc,Kc]=ctrbf(A,B,C);
nc=rank(ctrb(A,B),eps*100); 
n=length(A); ic=n-nc+1:n;
[Ao1,Bo1,Co1,To1,Ko1]=...
     obsvf(Ac(ic,ic),Bc(ic),Cc(ic));
if nc<n, inc=1:n-nc;
   [Ao2,Bo2,Co2,To2,Ko2]=...
       obsvf(Ac(inc,inc),Bc(inc),Cc(inc));
end
[m1,n1]=size(To1); [m2,n2]=size(To2);
To=[To2, zeros(m2,n1); zeros(m1,n2), To1]; 
T=To*Tc;
n1=rank(obsv(Ac(ic,ic),Cc(ic)),eps*100);
n2=rank(obsv(Ac(inc,inc),Cc(inc)),eps*100);
K=[zeros(1,n-nc-n2),ones(1,n2), ...
   2*ones(1,nc-n1), 3*ones(1,n1)];
Ak=T*A*inv(T); Bk=T*B; Ck=C*inv(T);
Gk=ss(Ak,Bk,Ck,G.d);

