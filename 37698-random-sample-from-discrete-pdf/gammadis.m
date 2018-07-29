%%gammadis(a,b,x): function returning a gamma pdf sampled at x
%%coords, gamma given by a/k and b/theta, depending on your notation.
function p = gammadis(a,b,x)
% return the gamma distribution with parameters a,b
% p = gammadis(a,b,x);

if nargin<3, 
   error('Requires three input arguments.'); 
end

p = (x.^(a-1)).*exp(-x/b)/((b^a)*gamma(a));
