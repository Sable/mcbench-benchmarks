function t=getInvHaarTransform(im,N)
h=haarmtx(N);
t=h'*im*h;