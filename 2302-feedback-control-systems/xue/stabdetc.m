function [V,ss]=stabdetc(A,X)
n=length(A); [nc,nr]=size(X); ss=[];
if nc==n & nr==1, A0=A; B0=X;
elseif nc==1 & nr==n, A0=A'; B0=X';
else, 
   error('uncompetible (A,B)'); V=[]; return;
end
C=ctrb(A0,B0); nB=rank(C);
if nB==n, V=1; 
else
   [Ac,Bc,Cc]=ctrbf(A0,B0,ones(1,n)); 
   Anc=Ac(1:n-nB,1:n-nB); ee=eig(Anc);
   for i=1:length(ee)
      if real(ee(i))>=0, ss=[ss,ee(i)]; end
   end
   if length(ss)>0, V=0; else, V=1; end
end
