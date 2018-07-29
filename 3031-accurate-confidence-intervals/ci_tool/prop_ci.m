% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: prop_ci.m
% computes confidence interval estimate of Binomial distribution parameter p.
%   x = number of positive outcomes (numerator of p_hat)
%   n = number of trials (denominator of p_hat)
%   alpha = probability that the true value will fall outside the confidence interval
%   method = 
%       1 for 1-sided confidence interval, 
%          note that you get both the lower 1-sided and the upper 1-sided when method = 1.
%       2 for 2-sided, minimum length interval (default)
%       3 for 2-sided, symmetrical about the estimate (except when either end of the interval would fall outside the acceptable range [0,1]
%       4 for 2-sided, equal tail masses
%       5 for 2-sided, MatLab implementation
%       6 for 2-sided, Normal approximation
%       7 for 2-sided, Law of Large Number approximation
%   ci = (p_hat, lower bound of confidence interval, upper bound of confidence interval)
%
% 010312 tdr created from prob_ci to allow all four methods.
% 010411 tdr added method to verbose output.
% 030106 tdr adjusted some comments
% 030306 tdr added "Method" to disp for verbose (mistakenly left out of 010411 change)
% 031223 tdr added test for NaN in inputs

function metrics = prop_ci(x,n,alpha,method,verbose)

% ------------------------------------------------------------
% start checking inputs

if nargin == 3, 
    method = 2;
    verbose = 0;
end

if nargin == 4, 
    verbose = 0;
end

if (nargin ~= 5 & nargin ~= 4 & nargin ~= 3), 
    error('Requires 3, 4, or 5 input arguments (x,n,alpha), (x,n,alpha,method), or (x,n,alpha,method,verbose)');
end

% inputs must all be scalars
if (max(max([size(x); size(n); size(alpha)])) ~= 1)
    error('Non-scalar input');   
end;

if isnan(x) | isnan(n) | isnan(alpha)
    warning('NaN input')
    metrics = [NaN, NaN, NaN];
    return
end;
 
% x and n must be integers
if (round(x) ~= x)
    x = round(x);
    warning('Non-integer input x');   
end;
if (round(n) ~= n)
    n = round(n);
    warning('Non-integer input n');   
end;

% n must be > 0
if (n <= 0),
   metrics = [ NaN NaN NaN];
   warning('n <= 0');
   return;
end;

% x must be >= 0 and <=n
if ( x < 0 | x > n),
   metrics = [ NaN NaN NaN];
   warning('x < 0 or x > n');
   return;
end;

% alpha must be > 0.0 and < 1.0
if ( alpha < 0 | alpha > 1),
   metrics = [ NaN NaN NaN];
   warning('alpha < 0 or alpha > 1');
   return;
end;

% verbose must be 0 or 1
if ( verbose ~= 0 & verbose ~= 1),
   metrics = [ NaN NaN NaN];
   warning('verbose not zero or one');
   return;
end;

% results may be inaccurate for n too large or alpha too small
if (n > 1e6), warning('n > 1e6, Results may not be accurate.'); end;
if (alpha < 1e-5), warning('alpha < 1e-5, Results may not be accurate.'); end;

% end checking inputs
% ------------------------------------------------------------
tic;
% call selected interval estimator method
switch method
case 1, % one-sided CI - note provides both upper and lower one-sided CIs
   ci = interval_est_p(x,n,alpha,'nibp_1s');
case 2, % minimum length CI
    ci = interval_est_p(x,n,alpha,'ml');
case 3, % symmetrical about estimate, expect when outside range
   ci = interval_est_p(x,n,alpha,'nibp');
case 4, % equal tail masses, note - may not enclose estimate
   ci = interval_est_p(x,n,alpha/2,'nibp_1s');
case 5, % MatLab's binofit.
    [p_hat ci_array] = binofit(x,n,alpha);
    ci = [p_hat ci_array(1) ci_array(2)];
case 6, % Normal Approximation
   ci = interval_est_p(x,n,alpha,'nap');
case 7, % Law of Large Numbers Approximation
   ci = interval_est_p(x,n,alpha,'lln');
otherwise
   error('Not a valid method: 1 (1-sided), 2 (min length), 3 (symm.), 4 (equal tail), 5 (MatLab-binofit), 6 (Normal Approx)');
end;
rt = toc;

if verbose
    length = ci(3)-ci(2);
    lower_tail = (n+1)*(integrate_binopdf(x,n,0,ci(2)));
    upper_tail = (n+1)*(integrate_binopdf(x,n,ci(3),1));
    if (method == 1)
        actual_alpha = (lower_tail + upper_tail)/2;
    else
        actual_alpha = lower_tail + upper_tail;
    end;
    if (abs(actual_alpha - alpha) > 0.00005) % close_enough is 0.00001 throughout, but spec is 0.0001.
        warning('Interval not to spec: abs(desired_alpha - actual_alpha) < 0.00005)');
        warning_stats = [alpha actual_alpha alpha-actual_alpha]
    end;
    disp('p_hat, Lower CI Bound, Upper CI Bound, x, n, Desired alpha, Method, Length, Lower Tail, Upper Tail, Actual alpha, Delta alpha, Run Time')
    metrics = [ci x n alpha method length lower_tail upper_tail actual_alpha (alpha - actual_alpha) rt];
    disp(sprintf('%8.6g, %8.6g, %8.6g, %d, %d, %8.6g, %d, %8.6g, %8.6g, %8.6g, %8.6g, %8.6g, %8.2g',metrics));
else
    metrics = ci;
end;


