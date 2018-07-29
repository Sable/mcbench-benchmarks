function c=counts(x,v)
% COUNTS counts the number of elements of x that fall within v
% COUNTS(x,v) returns the number of elements such that
% v(1)<=x, ....v(n-1)<x<=v(n)
c=[]; 
nv=[-Inf; v];
for i=2:rows(nv);
   t=sum(x<=nv(i) & x>nv(i-1));
   c(i-1,1)=t;
end
