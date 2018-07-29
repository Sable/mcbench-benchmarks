% Complex Normal generator
% N: numbers
% sig2: variance of the Complex Normal
function out=cxn(N,sig2)
    out=sqrt(sig2/2)*(randn(1,N)+i*randn(1,N));
end