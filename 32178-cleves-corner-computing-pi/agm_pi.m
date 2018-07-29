function P = agm_pi(d)
% AGM_PI  Arithmetic-geometric mean for pi.
% Brent-Salamin algorithm.
% agm_pi(d) produces d decimal digits.
% See Cleve's Corner, "Computing Pi",
% http://www.mathworks.com/company/ ...
%    newsletters/news_notes/2011/ 

% Copyright 2011 MathWorks, Inc.

digits(d)
a = vpa(1,d);
b = 1/sqrt(vpa(2,d));
s = 1/vpa(4,d);
p = 1;
n = ceil(log2(d));
for k = 1:n
   c = (a+b)/2;
   b = sqrt(a*b);
   s = s - p*(c-a)^2;
   p = 2*p;
   a = c;
end
P = a^2/s;
