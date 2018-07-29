function [intl] = embedbp(I,txt,b)
% EMBEDBP Embeds the data in the bth bit plane of the image
%
% [INTL] = EMBEDBP(I,TXT,B) embeds the string TXT in the Bth bit-plane of
% the image I and returns the watermarked image INTL. If B is not speified,
% it is taken as 1.
%
% See also RECOVERBP

if nargin == 2
    b=1;
end
N = 8*numel(txt);
S = numel(I);
if N > S
    warning('Text truncated to be within size of image')
    txt = txt(1:floor(S/8));
    N = 8*numel(txt);
end
p = 2^b;
h = 2^(b-1);
I1 = reshape(I,1,S);
addl = S-N;
dim = size(I);
I2 = round(abs(I1(1:N)));
si = sign(I1(1:N));
for k = 1:N
    if si(k) == 0
        si(k) = 1;
    end
    I2(k) = round(I2(k));
    if mod((I2(k)),p) >= h
        I2(k) = I2(k) - h;
    end
end
bt = dec2bin(txt,8);
bint = reshape(bt,1,N);
d = h*48;
bi = (h*bint) - d;
I3 = double(I2) + bi;
binadd = [bi zeros(1,addl)];
I4 = double(si).*double(I3);
I5 = [I4 I1(N+1:S)];
intl = reshape(I5,dim);
return