function [outdata] = rev_spatial_parse(indata)
% rev_spatial_parse  User-defined function for reverse spatial parsing.
% Input: 'inbits'
%    - input bits for spatial parsing.
% Output: 'outbits'
%    - spatial parsing output bits.

% Get spatial parsing info.
rate   = indata(1);
Nss    = indata(2);
ssize  = indata(3);
remdat = indata(4:end);
inbits = remdat(1:(end/2));
inbits = inbits(1:Nss*ssize);
mscale = remdat((1+end/2):end);
mscale = mscale(1:Nss*ssize);

% Init. rev. spatial parsing
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

% Bits: input/output streams...
ssbits1 = zeros(ssize, 1);
ssbits2 = zeros(ssize, 1);
ssbits3 = zeros(ssize, 1);
ssbits4 = zeros(ssize, 1);
outbits = zeros(4*ssize, 1);

% Metric scaling: input/output streams...
ssmscl1 = zeros(ssize, 1);
ssmscl2 = zeros(ssize, 1);
ssmscl3 = zeros(ssize, 1);
ssmscl4 = zeros(ssize, 1);
outmscl = zeros(4*ssize, 1);

% Do rev. spatial parsing...
s1 = 0;
s2 = nbits1;
s3 = nbits1+nbits2;
s4 = nbits1+nbits2+nbits3;
cnt = length(inbits)/totbits - 1;
if (Nss>=1)
    ssbits1 = inbits(1+end*0/Nss : end*1/Nss);
    ssmscl1 = mscale(1+end*0/Nss : end*1/Nss);
    for i=1:nbits1 % stream #1
        outbits(i+s1:totbits:i+s1+totbits*cnt) = ssbits1(i:nbits1:i+nbits1*cnt);
        outmscl(i+s1:totbits:i+s1+totbits*cnt) = ssmscl1(i:nbits1:i+nbits1*cnt);
    end
end
if (Nss>=2)
    ssbits2 = inbits(1+end*1/Nss : end*2/Nss);
    ssmscl2 = mscale(1+end*1/Nss : end*2/Nss);
    for i=1:nbits2 % stream #2
        outbits(i+s2:totbits:i+s2+totbits*cnt) = ssbits2(i:nbits2:i+nbits2*cnt);
        outmscl(i+s2:totbits:i+s2+totbits*cnt) = ssmscl2(i:nbits2:i+nbits2*cnt);
    end
end
if (Nss>=3)
    ssbits3 = inbits(1+end*2/Nss : end*3/Nss);
    ssmscl3 = mscale(1+end*2/Nss : end*3/Nss);
    for i=1:nbits3 % stream #3
        outbits(i+s3:totbits:i+s3+totbits*cnt) = ssbits3(i:nbits3:i+nbits3*cnt);
        outmscl(i+s3:totbits:i+s3+totbits*cnt) = ssmscl3(i:nbits3:i+nbits3*cnt);
    end
end
if (Nss>=4)
    ssbits4 = inbits(1+end*3/Nss : end*4/Nss);
    ssmscl4 = mscale(1+end*3/Nss : end*4/Nss);
    for i=1:nbits4 % stream #4
        outbits(i+s4:totbits:i+s4+totbits*cnt) = ssbits4(i:nbits4:i+nbits4*cnt);
        outmscl(i+s4:totbits:i+s4+totbits*cnt) = ssmscl4(i:nbits4:i+nbits4*cnt);
    end
end

% Reverse spatial parsing output
outdata = [outbits; outmscl];
