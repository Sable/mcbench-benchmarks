% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_ci_nap.m
% computes confidence interval
%  - assumes x is the number of successes in n Bernoulli trials
%  - finds confidence interval around the estimate for p
%  - with confidence level 1 - alpha
%  - method used is based on a normal approximation
%  - finds a symmetrical two-sided interval, unless one side
%    would cross zero or one, in which case the interval is 
%    offset.
%
% 022500 tdr created

function ci = get_ci_nap(x,n,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,n,alpha)');
end

p_hat=x/n;

zc=get_zc(alpha);

%delta_p = zc/(2*sqrt(n));
delta_p = zc*sqrt((p_hat*(1-p_hat))/n);

a = max([0 p_hat-delta_p]);	
b = min([p_hat+delta_p 1]);

ci=[p_hat max([p_hat-delta_p 0]) min([p_hat+delta_p 1])];

