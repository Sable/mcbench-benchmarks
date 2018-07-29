function f = factoradic(m,n)
% FACTORADIC - obtain the factorial radix of M
%    F = factoradic(M,N) returns the conversion of integer M into
%    factorial radix. F is a 1-by-N vector. The factoradic is also
%    known as the Lehmer Code. The factoradic of M is best 
%    understood by example.
%
%            Example:   89 = 3x4! + 2x3! + 2x2! + 1x1! + 0x0!
%                       therefore factoradic(89,5) = (3,2,2,1,0)
%    
%    M must lie in the range [0 : N!-1].
%    Leading zeros will be present in F when M < (N-1)!-1.
%
%            Example:   factoradic(19,6) = (0,0,3,0,1,0)
%
%    Note that the last value in the factoradic is always zero. 
%    The factoradic of M is closely related to the M-th permutation 
%    of 1:N. See ONEPERM on the File Exchange.

% for Matlab (should work for most versions)
% version 1.0 (Feb 2009)
% (c) Darren Rowland
% email: darrenjrowland@hotmail.com
%
% Algorithm adapted from article by James McCaffrey (MSDN) accessed Feb09
% http://msdn.microsoft.com/en-us/library/aa302371.aspx
%
% Keywords: factoradic, factorial radix, Lehmer Code, permutation

error(nargchk(2,2,nargin));
if numel(m) ~= 1 || m <= 0 || m ~= round(m)
  error('onecomb:InvalidArg1',...
        'The first input has to be a non-negative integer');
end
if numel(n) ~= 1 || n <= 0 || n ~= round(n)
  error('onecomb:InvalidArg2',...
        'The second input has to be a non-negative integer');
end
if m>factorial(n)-1
     error('factoradic:largeM','M should not exceed N!-1');
end

f = zeros(1,n);
jj = 2;
while m~=0
    f(n-jj+1) = mod(m,jj);
    m = floor(m/jj);
    jj = jj+1;
end