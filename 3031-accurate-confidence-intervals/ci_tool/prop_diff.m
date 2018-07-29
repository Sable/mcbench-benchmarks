% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: prop_diff.m
%
% 010426 tdr created
% 010524 tdr added delta
% 021220 tdr added checks on range of input values
% 030109 tdr went to mean+- stdev approach on int limits (replacing a search)
% 030111 tdr included delta in lower bound
% 030116 tdr changed to use 10 std deviations (in place of 20) to prevent quadl failure in some cases

function y = prop_diff(x1,n1,x2,n2,delta)
% x - number of positive events
% n - number of trials
% delta - the difference of interest
% y - Pr (p1 - p2 >= delta), where p1_hat = x1/n1 and p2_hat = x2/n2

if nargin ~= 5, error('Requires five input arguments (x1,n1,x2,n2,delta)'); end
if ((x1 > n1) | (x2 > n2)), error('x must not be greater than n'); end
if ((n1 < 1) | (n2 < 1)), error('n must not be less than 1'); end
if ((delta < -1) | (delta > 1)), error('delta must be in [-1,1]'); end
if ((n1 > 1e6) | (n2 > 1e6)), warning('n > 1e6, results may not be accurate'); end

% see SPIE'01 paper for proportion posterior distribution in terms of beta functions.
a1 = x1+1; b1 = n1-x1+1;
a2 = x2+1; b2 = n2-x2+1;

% if tolerance and integration limits aren't adjusted then the narrow bumps in the integrand (that are the entirety of some distributions) are missed by quadl,
tolerance = 1.0e-9;
trace = 0;
epsilon = 1.0e-15;

% we want to integrate from minus to plus infinity, but betapdf is non-zero only between zero and one.
%lower_bound = 0; upper_bound = 1.0;

% we want to integrate from minus to plus infinity, but we assume the pdf's are zero well away from their means.
% p is beta dist, mean of a beta dist is a/(a+b), mode is (a-1)/(a+b-2), std dev of beta dist is sqrt(ab/((a+b)^2 (a+b+1)))
% delta is a lower bound because the beta distributions are zero for negative arguments
% we're concerned with p2's cdf, so it only affects the lower_bound
no_std_dev = 20;  % set based on trial and error
mean1 = a1/(a1+b1);  sd1 = sqrt((a1*b1)/(((a1+b1)^2)*(a1+b1+1)));
mean2 = a2/(a2+b2)+delta;  sd2 = sqrt((a2*b2)/(((a2+b2)^2)*(a2+b2+1)));
lower_bound = max([0 (mean1-no_std_dev*sd1) mean2-no_std_dev*sd2 delta]);
upper_bound = min([mean1+no_std_dev*sd1 1]);
width = upper_bound-lower_bound;

if (lower_bound < upper_bound)
    y = quadl('prop_diff_integrand',lower_bound,upper_bound,tolerance,trace, a1,b1,a2,b2,delta);
else
    y = 0;
end;

% prevent rounding error from getting the probability outside of [0,1]
y = min(y,1.0);
y = max(y,0.0);

