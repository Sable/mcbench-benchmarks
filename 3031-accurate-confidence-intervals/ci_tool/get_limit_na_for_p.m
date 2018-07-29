% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_limit_na_for_p.m
%
% Provides the lower limit on min (x/n, 1-x/n) for nap to be an adequate approximation.
%
% Change History:
%	033100 tdr created by breaking out of get_ci_cs1.m

function NAp_limit = get_limit_na_for_p(x,n,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,n,alpha)');
end;

p_hat = x/n;
q = min(p_hat, 1-p_hat);

% smaller alpha's require larger n's to make NAp good for q's down to 0.2
if (alpha >= 0.01 & n>=1000) | ...
	(alpha >= 0.05 & n>=500) | ...
	(alpha >= 0.1 & n >=250),
	NAp_limit = 0.2;
else 
	NAp_limit = 0.5; % i.e., don't use NAp
end;
