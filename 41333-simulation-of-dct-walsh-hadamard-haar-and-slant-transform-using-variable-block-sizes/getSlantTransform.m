function t=getSlantTransform(im,N)
s=sltmtx(log2(N));
t=s*im*s';