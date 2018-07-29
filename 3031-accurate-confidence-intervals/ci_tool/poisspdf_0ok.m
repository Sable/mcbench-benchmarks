% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: poisspdf_0ok.m
% The regular poisspdf returns NaN whenever lambda = 0.
% The correct value for binopdf to return is 1.0 for x=0 and 0.0 otherwise.
% This corrects that bug.
% This could more easily be fixed within poisspdf.m, but that
%   violates copyrights.
%
% 022400 tdr created
% 031600 tdr created from binopdf_01ok.m

function y = poisspdf_0ok(x,lambda)

if nargin < 2, 
    error('Requires two input arguments (x,lambda)');
end

[errorcode x lambda] = distchck(2,x,lambda);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

y = zeros(size(x));

k = find(~(lambda == 0));
if any(k),
	y(k) = poisspdf(x(k),lambda(k));
end

k = find(lambda == 0);
if any(k),
   y(k) = 0;
end

k = find((x == 0) & (lambda == 0));
if any(k),
   y(k) = 1;
end
