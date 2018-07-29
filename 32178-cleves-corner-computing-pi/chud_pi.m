function P = chud_pi(d)
% CHUD_PI  Chudnovsky algorithm for pi.
% chud_pi(d) produces d decimal digits.
% See Cleve's Corner, "Computing Pi",
% http://www.mathworks.com/company/ ...
%    newsletters/news_notes/2011/ 

% Copyright 2011 MathWorks, Inc.

k = sym(0);
s = sym(0);
sig = sym(1);
n = ceil(d/14);
for j = 1:n
   s = s + sig * prod(3*k+1:6*k)/prod(1:k)^3 * ...
       (13591409+545140134*k) / 640320^(3*k+3/2);
   k = k+1;
   sig = -sig;
end
S = 1/(12*s);
P = vpa(S,d);
