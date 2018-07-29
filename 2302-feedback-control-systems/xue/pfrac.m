function [R,P,K]=pfrac(G)
G=tf(G); 
[R,P,K]=residue(G.num{1},G.den{1}); 
for i=1:length(R),
   if imag(P(i))>eps
      a=real(R(i)); b=imag(R(i));
      R(i)=-2*sqrt(a^2+b^2); 
      R(i+1)=atan2(-a,b);
   end
end
