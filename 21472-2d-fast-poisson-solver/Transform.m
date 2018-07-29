%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%
% Fast sine transform for poisson.m.  Only need one since our Q matrix is orthogonal
function s = Transform(m,p)
const = -sqrt(2/(m+1));
for k = 1:m
   % Take the kth vector from the long vector, p, and set it to q.
   q = p((k-1)*m +1:k*m);
   % Take the 2*m +2 fft of [0;q]
   w = const*(fft([0;q],2*m+2));
   % Take imaginary part of w and throw away the first element and last m+1 elements.
   s((k-1)*m +1:k*m) = imag(w(2:m+1));
end
%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%