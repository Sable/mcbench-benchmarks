function K=bass_plc(A,B,p)
n=length(B); a1=poly(p);
alpha=[a1(n:-1:2),1];
a=poly(A); aa=[a(n:-1:2),1];
L=hankel(aa); C=ctrb(A,B);
K=(a1(n+1:-1:2)-a(n+1:-1:2))*inv(L)*inv(C);