function outvec = SHSetValue(invec,value,l,m,N,lmax,both)

% outvec = SHSetValue(invec,value,l,m[,N,lmax][,both])
%
% Sets the spherical harmonic coefficient vector entry corresponding
% to degree l and order m to the specified value. If optional arguments
% N and lmax are specified, invec is treated as a set of sections as
% described by lmax, and the value corresponding to sections N is set.
% If lmax is specified, it must be a vector describing the spherical
% harmonics degrees lmax for each of the sections 1 .. length(lmax).
% If 'both' is given, set both positive and negative order coefficients.
 
outvec = invec;

if l<0
    error('invalid usage: l has to be a non-negative integer');
end

if m>l
    error('invalid usage: l has to be greater or equal to m');
end

if nargin < 5
    N=1;
end

n=zeros(length(N),1);

if nargin == 5
    error('please provide sixth argument: array of lmax values');
elseif nargin > 5
    if find(N>length(lmax))>0 | find(N<1)>0 %#ok<OR2>
        error('unable to set the value since section N is not present');
    elseif find(lmax(N)<l)
        error('unable to set the values for l,m: degree is less than l');
    else
        for j=1:length(N)
            for i=1:N(j)-1
                n(j) = n(j) + SHl2n(lmax(i));
            end
        end
    end
end

n = n + SHlm2n(l,m);

if n>length(invec)
    error('invalid usage: index %d exceeds the length of the vector',n);
end

outvec(n)=value;

if nargin <= 6
    return;
end

n = n - SHlm2n(l,m) + SHlm2n(l,-m);

outvec(n)=value;
