function [v,ierr]=geth2(G)
G=tf(G); num=G.num{1}; den=G.den{1};
ierr=0; v=0; n=length(den); 
if abs(num(1))>eps
   disp('System not strictly proper '); 
   ierr=1; return
else, a1=den; b1=num(2:length(num)); end
for k=1:n-1
  if (a1(k+1)<=eps), ierr=1; return
  else,
     alpha=a1(k)/a1(k+1); beta=b1(k)/a1(k+1);
     v=v+beta*beta/alpha; k1=k+2;
     for i=k1:2:n-1
        a1(i)=a1(i)-alpha*a1(i+1);
        b1(i)=b1(i)-beta*a1(i+1);
     end,
  end,
end
v=sqrt(0.5*v);
