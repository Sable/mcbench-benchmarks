function y = PhaseMod(x, bits)
% function y = PhaseMod(x, bits)
%
% This function performs phase modulation using l bits per symbol.  Thus the
% modulation is (2^bits)-PSK.  The return vector y is complex baseband.

l=bits;

M = 2^l;

if size(x,1)==1
   x = x.';
end

a = size(x,1);

x = num2str(x);

s = reshape(x,a/l,l);


ss = bin2dec(s);

y = exp(j*2*pi*ss/M);
