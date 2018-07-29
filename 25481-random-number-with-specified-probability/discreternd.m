function x = discreternd(p, n)
% generate random number from a discrete distribution specified by
% parameter p. If sum(p)~=1, then p specifies the relative ratio.
% Written by Mo Chen (mochen@ie.cuhk.edu.hk). March 2009.
if nargin == 1
    n = 1;
end

r = rand(1,n);   % rand numbers are in the open interval (0,1)
p = cumsum(p(:));
% x = sum(repmat(r,length(p),1) > repmat(p/p(end),1,n),1)+1;
[dum,x] = histc(r,[0;p/p(end)]);
