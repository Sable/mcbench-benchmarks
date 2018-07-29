% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_ci_ibp.m
% computes confidence interval
%  - assumes x is the number of successes in n Bernoulli trials
%  - finds confidence interval around the estimate for p
%  - with confidence level 1 - alpha
%  - method used is based on integrating f(p|x)
%  - finds a symmetrical two-sided interval, unless one side
%    would cross zero or one, in which case the interval is 
%    offset.
%
% Two methods of integration are used -
%  - for small n (n<500), the recursive method is faster
%  - for large n, the numerical integration method is faster
%    even if it weren't, the recursive method overflows the
%    stack for very large n (n>800).
%
% 022300 tdr created
% 022800 tdr changed from numerical integration to CRC recursive soln.
% 030600 tdr changed to use nibp and ribp conditioned on n.
% 033100 tdr changed threshold for using ribp to depend on min(x, n-x) rather than just n.
% 012901 tdr set N_THRES to zero, i.e., always use numerical intergration.  
%   numerical is slower,  taking up to one-third of a second on 800MHz PC
%   recursive has warnings for nchoosek being called with large n.
%   In comparing the CIs on n's between 1 and 400 with alphas of 0.01 and 0.05 and 
%   x's between 0 and n, the differences in the CI limits were all less than 0.001.

function ci = get_ci_ibp(x,n,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,n,alpha)');
end

%N_THRES = 400;
N_THRES = 0;

if n < N_THRES,
%    disp(sprintf('%d, %d, %8.6f, %s', x, n, alpha,'ribp'))
   ci = get_ci_ribp(x,n,alpha);
else
%    disp(sprintf('%d, %d, %8.6f, %s', x, n, alpha,'nibp'))
   ci = get_ci_nibp(x,n,alpha);
end;
