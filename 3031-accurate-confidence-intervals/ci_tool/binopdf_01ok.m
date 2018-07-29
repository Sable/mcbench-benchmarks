% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: binopdf_01ok.m
% The regular binopdf returns NaN whenever x=0 and p=0 or whenever 
%   x=n and p=1.  The correct value for binopdf to return in both cases is 1.0.
% This corrects that bug.
% This also avoids calling binopdf when it would give an inappropriate warning
%   about taking the log of zero.
% This could more easily be fixed within binopdf.m, but that for MathWorks
%
% 022400 tdr created
% 033100 tdr added check for binopdf returning NaN or Inf, which it may for n > 1000, e.g., x=500, n=1030, p=0.1

function y = binopdf_01ok(x,n,p)

if nargin < 3, 
    error('Requires three input arguments (x,n,p)');
end

[errorcode x n_bar p] = distchck(3,x,n,p);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

y = zeros(size(x));

k = find(~((p == 0) | (p == 1)));
if any(k),
   y(k) = binopdf(x(k),n,p(k));
   if ~isfinite(y),
      error('NaN or Inf value returned from binopdf.m')
   end;
end

k = find((x ~= 0 & p == 0) | (x ~= n & p == 1));
if any(k),
   y(k) = 0;
end

k = find((x == 0 & p == 0) | (x == n & p == 1));
if any(k),
   y(k) = 1;
end


