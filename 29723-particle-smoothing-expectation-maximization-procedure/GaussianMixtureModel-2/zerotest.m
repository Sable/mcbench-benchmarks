function [n1,val]=zerotest(y,m,w)
[m,n1]=min(abs(y-m));
if sum(w)==0
val=1;
else
val=w(n1);
end