% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: rate_diff.m

% 010507 tdr created from prop_diff.m
% 021220 tdr added checks on ranges of input values
% 030109 tdr adjusted integration limits
% 030113 tdr fixed bug (delta had been left out of lower bound)

function y = rate_diff(x1,A1,x2,A2,delta)
% x - number of observed false alarms
% A - area searched
% delta - amount of difference in the rates
% y - Pr ( r1 - r2 >= delta), where r1_hat = x1/A1 and r2_hat = x2/A2

if nargin ~= 5, error('Requires five input arguments (x1,A1,x2,A2,delta)'); end
if ((x1 < 0) | (x2 < 0)), error('x must not be less than 0'); end
if ((A1 < 0) | (A2 < 0)), error('A must not be less than 0'); end
if ((x1 > 1e6) | (x2 > 1e6)), warning('x > 1e6, results may not be accurate'); end
if ((A1 > 1e6) | (A2 > 1e6)), warning('A > 1e6, results may not be accurate'); end

% see SPIE'01 paper, Section 5.4, for rate posterior distribution in terms of gamma functions.
a1 = x1+1; b1 = 1;
a2 = x2+1; b2 = 1;

% if tolerance and integration limits aren't adjusted then the narrow bumps in the integrand (that are the entirety of some distributions) are missed by quadl,
tolerance = 1.0e-9;
trace = 0;
epsilon = 1.0e-15;

% we want to integrate from minus to plus infinity, but we assume the pdf's are zero well away from their means.
% mean of r is (1/A)* mean of lambda, std deviation of r is (1/A)* std dev of lambda
% lambda is gamma dist, mean of a gamma dist is a*b, std dev of gamma dist is sqrt(a)*b
% we're using normalized areas (i.e., divided by A2)
% delta is a lower bound because the gamma distributions are zero for negative arguments
% we're concerned with r2's cdf, so it only affects the lower_bound
no_std_dev = 10; % set based on trial and error
mean1 = a1*b1/(A1/A2);  sd1 = sqrt(a1)*b1/(A1/A2);
mean2 = a2*b2 + delta*A2;  sd2 = sqrt(a2)*b2;
lower_bound = max([0 (mean1-no_std_dev*sd1) (mean2-no_std_dev*sd2) delta*A2]);
upper_bound = mean1+no_std_dev*sd1;
%disp(sprintf('%25.22g, %25.22g',lower_bound, upper_bound));
if (lower_bound < upper_bound)
    y = quadl('rate_diff_integrand',lower_bound,upper_bound,tolerance,trace,a1,b1,A1/A2,a2,b2,1.0,delta * A2);
else
    y = 0;
end;

% prevent rounding error from getting the probability outside of [0,1]
y = min(y,1.0);
y = max(y,0.0);
