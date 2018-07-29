function y=fft_circshift(u,d)
%y=fft_circshift(u,d)
%This performs a circular shift of d samples on u, using a linear phase
%shift in the Fourier domain. The shift, d, need not be an integer.  Some 
%information is lost if there are an even number of samples and there is 
%frequency content at the Nyquist frequency, since this frequency cannot 
%be shifted and is disregarded.

%There is probably room for speedwise improvement in this code.

%    Copyright Travis Wiens 2009 travis.mlfx@nutaksas.com

U=fft(u);

N_p=numel(u);

if (mod(N_p, 2) == 0)
    U(length(U)/2+1)=0;%disregard Nyquist frequency for even-sized dft
end

f=(mod(((0:N_p-1)+floor(N_p/2)), N_p)-floor(N_p/2))/N_p;
c_shift=exp(-2i*pi*d .*f);
Y=U.*c_shift;
y=ifft(Y);
