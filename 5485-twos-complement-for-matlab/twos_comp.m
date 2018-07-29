function [twos, sign] = twos_comp(x, bits)
% compute the 2's complement number for 16 bit short
% Written by Tal Levinger,   13/07/04

lut_2 = [ 1   2   4   8   16   32    64    128    256   512   1024   2048   4096   8192    16384   32768];

if bitget(x, 16) == 0,
    sign = 1;
    twos = x;
else
    x = bitget(x, 1:16);
    sign = -1;
    x = ~x;

    carry = 1;
    for i=1:16,
        y = x(i) + carry;
        if (y == 2),
            carry = 1;
            x(i) = 0;
        else
            x(i) = y;
            carry = 0;
        end
    end
    twos = sign * sum(x .* lut_2);
end