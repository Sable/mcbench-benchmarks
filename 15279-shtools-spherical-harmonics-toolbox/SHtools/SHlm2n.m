function n = SHlm2n(l,m)

% n = SHlm2n(l,m)
%
% For given real spherical harmonic coefficient degree l and order m
% where negative m corresponds to sin(phi) and positive m corresponds
% to cos(phi) terms output the integer index n in the real spherical
% harmonic coefficient array

if l<0
    error('invalid usage: l has to be a non-negative integer');
end

if m<=0 
    j=1;
else
    j=0;
end

m=abs(double(m));
if m>l
    error('invalid usage: l has to be greater or equal to m');
end
    
k=0:(l-1);

if l==0 
    n = 1;
else
    n = sum(2*k+1)+2*m+j;
end