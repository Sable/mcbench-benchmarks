function t=getHadamardTransform(im,N)
h=hadamard(N);
m=log2(N);
t=(1/(2^m))*h*im*h';