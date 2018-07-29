function [ sum ] = disthamming( x,y )
% By: Francisco Carlos Calderón Bocanegra
% disthamming Find the  hamming distance betwen two unsigned integer numbers
% this must be uint8, uint16, uint32 or uint64
% under Open source BSD licence
% http://www.opensource.org/licenses/bsd-license.php

isuint8=isa(x, 'uint8'); % returns true
isuint16=isa(x, 'uint16'); % returns true
isuint32=isa(x, 'uint32'); % returns true
isuint64=isa(x, 'uint64'); % returns true
    if isuint8
        z = bitxor(x, y);
        sum=0;
        for i=1:8
            sum = sum + bitget(z,i);
        end
    end
    if isuint16
        z = bitxor(x, y);
        sum=0;
        for i=1:8
            sum = sum + bitget(z,i);
        end
    end
    if isuint32
        z = bitxor(x, y);
        sum=0;
        for i=1:32
            sum = sum + bitget(z,i);
        end
    end
    if isuint64
        z = bitxor(x, y);
        sum=0;
        for i=1:64
            sum = sum + bitget(z,i);
        end
    end
end

