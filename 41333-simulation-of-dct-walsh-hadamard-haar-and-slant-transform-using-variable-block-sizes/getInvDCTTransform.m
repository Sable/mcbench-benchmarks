function t=getInvDCTTransform(im,N)
s=dctmtx(N);
t=s'*im*s;