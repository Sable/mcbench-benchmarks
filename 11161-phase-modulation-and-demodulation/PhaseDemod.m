function y=PhaseDemod(x, bits)
%function y=PhaseDemod(x, bits)
%
% This function demodulates M-PSK with M=2^bits symbols
% This function should be used with PhaseMod.m

M = 2^bits;


if size(x,1) ==1 
   x = x.';
end

ss = 0:M-1;
symbols = exp(j*2*pi*ss/M);
b = dec2bin(0:M-1);

for i=1:M
   e(i,:) = symbols(i)-x.';
end

[min,index] = min(abs(e));

y = b(index,:);

y = reshape(y, bits*size(y,1),1);

y = str2num(y).';

