

function [decimal] = twos2decimal(x,bits)
%  twos2decimal(data,bits)  convert 2s complement to decimal
%                           data - single value or array to convert
%                           bits - how many bits wide is the data (i.e. 8
%                           or 16)
decimal=zeros(length(x),1);
for i=1:length(x),
    if bitget(x(i),bits) == 1,
        decimal(i) = (bitxor(x(i),2^bits-1)+1)*-1;
    else
        decimal(i) = x(i);
    end
end
