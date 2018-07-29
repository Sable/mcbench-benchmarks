function x=rand_white(N);
%x=rand_white(N);
%Generates white noise with a constant fft and variance 1.
%N must be even.

%    Copyright Travis Wiens 2009 travis.mlfx@nutaksas.com

X=ones(1,N);
phase=2*pi*rand(1,N/2-1);
X(2:N/2)=X(2:N/2).*exp(2i*pi*phase);
X((N/2+2):end)=conj(fliplr(X(2:N/2)));
x=sqrt(N)*real(ifft(X));
