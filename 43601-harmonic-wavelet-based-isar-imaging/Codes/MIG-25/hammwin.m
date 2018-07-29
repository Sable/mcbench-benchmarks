function x= hammwin(N)
% Function HAMMWIN(N) creates the N-point Hamming window.

n=0 : N-1;
x=0.54 - 0.46 * cos(2 * pi * n/(N-1));