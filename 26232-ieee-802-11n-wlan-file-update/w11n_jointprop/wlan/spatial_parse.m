function [outbits] = spatial_parse(indata)
% spatial_parse  User-defined function for spatial parsing.
% Input: 'inbits'
%    - input bits for spatial parsing.
% Output: 'outbits'
%    - spatial parsing output bits.

% Get spatial parsing info.
rate   = indata(1);
Nss    = indata(2);
ssize  = indata(3);
inbits = indata(4:end);

% Init. spatial parsing
switch rate
    case {1}
        nbits1 = 1;
    case {2,3}
        nbits1 = 2;
    case {4,5}
        nbits1 = 4;
    case {6,7,8}
        nbits1 = 6;
    otherwise
        nbits1 = 1;
end
nbits2 = nbits1;  nbits3 = nbits1;  nbits4 = nbits1;

switch Nss
    case 1
        totbits = nbits1;
    case 2
        totbits = nbits1 + nbits2;
    case 3
        totbits = nbits1 + nbits2 + nbits3;
    case 4
        totbits = nbits1 + nbits2 + nbits3 + nbits4;
end

% Init streams...
ssbits1 = zeros(ssize, 1);
ssbits2 = zeros(ssize, 1);
ssbits3 = zeros(ssize, 1);
ssbits4 = zeros(ssize, 1);

% Do spatial parsing...
s1 = 0;
s2 = nbits1;
s3 = nbits1+nbits2;
s4 = nbits1+nbits2+nbits3;
cnt = length(inbits)/totbits - 1;
if (Nss>=1)
    for i=1:nbits1 % stream #1
        ssbits1(i:nbits1:i+nbits1*cnt) = inbits(i+s1:totbits:i+s1+totbits*cnt);
    end
end
if (Nss>=2)
    for i=1:nbits2 % stream #2
        ssbits2(i:nbits2:i+nbits2*cnt) = inbits(i+s2:totbits:i+s2+totbits*cnt);
    end
end
if (Nss>=3)
    for i=1:nbits3 % stream #3
        ssbits3(i:nbits3:i+nbits3*cnt) = inbits(i+s3:totbits:i+s3+totbits*cnt);
    end
end
if (Nss>=4)
    for i=1:nbits4 % stream #4
        ssbits4(i:nbits4:i+nbits4*cnt) = inbits(i+s4:totbits:i+s4+totbits*cnt);
    end
end

% spatial parsing output
outbits = [ssbits1; ssbits2; ssbits3; ssbits4];

