function Gc=predpi(vars)
K=vars(1); L=vars(2); 
T=vars(3); m=vars(4); 
lam=vars(5); [nP,dP]=pade(L,m);
dd=conv([lam*T,1],dP)-[0,nP];
nn=conv(lam*[T,1],dP); Gc=tf(nn,dd);


