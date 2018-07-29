function ind = ichoose(n,k)
%ICHOOSE Choose K indices from the set 1:N.
%   ICHOOSE(N,K) gives all combinations of choosing K indices from
%   the set 1:N without order and without repetitions.
%
%   Example:
%   	ind = ichoose(4,2);
%   	v = 'ABCD';
%   	v(ind) % ['AB';'AC';'AD';'BC';'BD';'CD']
%
%   See also NCHOOSEK

%   Author: Jonas Lundgren <splinefit@gmail.com> 2011

% Check input
if ~isscalar(n) || ~isfinite(n) || n < 0 || fix(n) < n
    error('ICHOOSE:N','N must be a non-negative integer.')
elseif ~isscalar(k) || ~isfinite(k) || k < 0 || fix(k) < k
    error('ICHOOSE:K','K must be a non-negative integer.')
elseif n < k
    ind = zeros(0,k);
    return
elseif k == 0
    ind = zeros(1,0);
    return
end

% Initiate indices
if n < 256
    ind = uint8(k:n)';
elseif n < 65536
    ind = uint16(k:n)';
else
    ind = (k:n)';
end

m = n-k+1;
b = 1:m;

% Generate indices
for j = 1:k-1
    a = b;
    b = cumsum(b);
    c = b(m) + 1 - b(1:m-1);
    if m > 1
        p = ones(b(m),1);
        p(c) = 1 - a(1:m-1);
        p = cumsum(p);
        ind = ind(p,:);
    end
    p = zeros(b(m),1);
    p(1) = k-j;
    p(c) = 1;
    p = cumsum(p);
    ind = [p,ind]; %#ok
end
