function [l,m] = SHn2lm(n)

% [l,m] = SHn2lm(n)
%
% For a given integer index n in the real spherical harmonic coefficient
% array, find the corresponding degree l and order m, so that
% negative m corresponds to sin(phi) and positive m corresponds
% to cos(phi) terms

if n<=0 
    error('invalid usage: n has to be greater than zero');
end

if n==1
    l=0; m=0; return;
end

l=0;
while 1
    l=l+1;
    k=0:(l-1); 
    if (sum(2*k+1)>=n)
        break;
    end
end
l=l-1;

k=0:(l-1);
rem = n - sum(2*k+1);

if mod(rem,2) == 0
    m=rem/2;
else
    m=-(rem-1)/2;
end

%varargout{1}=l;
%varargout{2}=m;