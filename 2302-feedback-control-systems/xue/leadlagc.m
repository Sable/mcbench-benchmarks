function Gc=leadlagc(G,Wc,Gam_c,Kv,key)
G=tf(G); [Gai,Pha]=bode(G,Wc);
Phi_c=sin((Gam_c-Pha-180)*pi/180);
den=G.den{1}; a=den(length(den):-1:1);
ii=find(abs(a)<=0); num=G.num{1}; 
G_n=num(length(num));
if length(ii)>0
   if ii(1)>1, a=a(ii(1)+1);
   else, a=a(ii(1)+1); end
else, a=a(1); end;
alpha=sqrt((1-Phi_c)/(1+Phi_c));
Zc=alpha*Wc; Pc=Wc/alpha;
Kc=sqrt((Wc*Wc+Pc*Pc)/(Wc*Wc+Zc*Zc))/Gai;
K1=G_n*Kc*alpha/a;
if nargin==4, key=1;
   if Phi_c<0, key=2;
   else, if K1<Kv, key=3; end, end
end
switch key
   case 1, Gc=tf([1 Zc]*Kc,[1 Pc]);
   case 2
      Kc=1/Gai; K1=G_n*Kc/a;
      Gc=tf([1 0.1*Wc],[1 K1*Gcn(2)/Kv]); 
   case 3
      Zc2=Wc*0.1; Pc2=K1*Zc2/Kv;
      Gcn=Kc*conv([1 Zc],[1,Zc2]);
      Gcd=conv([1 Pc],[1,Pc2]); 
      Gc=tf(Gcn,Gcd);
end
