% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_ci_cs1.m
%
% Purpose: computes confidence intervals on a probability estimate
%
% This routine is more accurate, but slower under some conditions,
% (perhaps two orders-of-magnitude difference - both in run time and accuracy)
% than other methods and does use non-trivial MatLab routines.
%
% See also: get_ci_cs2.m, which is fast, conservative (doesn't understate the CI)
% and does not rely on non-trivial MatLab routines (i.e., could be easily 
% implemented in C).  
%
% Change History:
%  030600 tdr created
%  033100 tdr added can_use_ibp to deal ibp problems
%					ribp fails if n or min(x, n-x) are too big - inaccurate or recursion depth respectively
%					nibp fails if n and min(x, n-x) are too big - binopdf limitation
%  030106 tdr adjusted some comments

function ci = get_ci_cs1(x,n,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,n,alpha)');
end;

p_hat = x/n;
q = min(p_hat, 1-p_hat);

NAp_limit = get_limit_na_for_p(x,n,alpha);

can_use_ibp = 0;
if (n < 1000) | (min(x, n-x) < 100),
   can_use_ibp = 1;
end;

if (q > NAp_limit) | ~can_use_ibp,
	method = 'nap';
else
	method = 'ibp';
end;
   
ci = interval_est_p(x,n,alpha,method);
