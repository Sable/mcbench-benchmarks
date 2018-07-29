function t=getInvSlantTransform(im,N)
s=sltmtx(log2(N));
t=s'*im*s;