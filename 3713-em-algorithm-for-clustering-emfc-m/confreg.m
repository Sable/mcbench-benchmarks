function y = confreg(mu,S,n,a)
%CONFREG(mu,S,n,a) plots an 95% confidence region for the means based on the
%approach of T-square of Hotelling to the F distribution, with 2,n-2 df's
%in the 2 dimensional case.

p=2;
xbar=mu(1,1);
ybar=mu(2,1);
sigmax=S(1,1);
sigmay=S(2,2);
covxy=S(1,2);
F=finv(1-a,p,n-p);

syms x y ;
s=([x-xbar y-ybar]*inv([sigmax covxy;covxy sigmay])*[x-xbar;y-ybar])-p*((n)/(n-p))*F;
s=simplify(s);
ezplot(s,[-14 15]);
grid;
zoom(10);
