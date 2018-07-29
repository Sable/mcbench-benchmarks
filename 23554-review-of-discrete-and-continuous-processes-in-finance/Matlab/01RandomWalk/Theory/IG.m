function X=IG(l,m,J)

N=randn(J,1);
Y=N.^2;
X = m + (.5*m*m/l)*Y - (.5*m/l)*sqrt(4*m*l*Y+m*m*(Y.^2));
U=rand(J,1);

I=find(U>m./(X+m));
X(I)=m*m./X(I);
