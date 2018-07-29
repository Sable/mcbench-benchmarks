function y = frconv(h,u)

h = h(:).';
u = u(:).';

N = length(u);
M = length(h);

H = fft([h zeros(1,N-1)]);
U = fft([u zeros(1,M-1)]);

y = ifft(H.*U);