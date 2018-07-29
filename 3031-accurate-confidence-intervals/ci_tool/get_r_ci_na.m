% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_r_ci_na.m
% computes confidence interval for a rate estimate using the normal approximation
%  - assumes x is the number of occurrances of an event in area A
%  - finds confidence interval around the estimate for rate R
%  - with confidence level 1 - alpha
%  - method used is based on a normal approximation
%  - finds a symmetrical two-sided interval, unless one side
%    would cross zero or one, in which case the interval is 
%    offset.
%
% 022500 tdr created
% 031600 tdr created rate version from probability est version

function ci = get_r_ci_na(x,A,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,A,alpha)');
end

r_hat=x/A;

zc=get_zc(alpha);

delta_r = zc * sqrt(x) / A;

ci=[r_hat max([r_hat-delta_r 0]) r_hat+delta_r];
