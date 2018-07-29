function M=timmomt(G,k)
G=ss(G); C=G.c; B=G.b;
iA=inv(G.a); iA1=iA; M=zeros(1,k);
for i=1:k
   M(i)=-C*iA1*B; iA1=iA*iA1;
end

   