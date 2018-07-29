function t=getWalshTransform(im,N)
h=walsh(N);
m=log2(N);
t=(1/(2^m))*h*im*h';