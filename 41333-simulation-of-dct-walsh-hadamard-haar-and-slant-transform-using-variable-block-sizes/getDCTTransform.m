function t=getDCTTransform(im,N)
s=dctmtx(N);
t=s*im*s';