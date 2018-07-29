% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: rate_ci.m
% computes confidence interval estimate rates.
%   x = number of events (numerator of r_hat)
%   A = test area (denominator of p_hat) - the CI will be in the same units as the rate,
%       which is in the same units as 1/A.
%   alpha = probability that the true value will fall outside the confidence interval
%   method = 
%       1 for 1-sided confidence interval, 
%          note that you get both the lower 1-sided and the upper 1-sided when method = 1.
%       2 for 2-sided, minimum length interval (default)
%       3 for 2-sided, symmetrical about the estimate (except when either end of the interval would fall outside the acceptable range [0,1]
%       4 for 2-sided, equal tail masses
%       5 for 2-sided, MatLab implementation
%       6 for 2-sided, Normal approximation
%   ci = (r_hat, lower bound of confidence interval, upper bound of confidence interval)
%       note that you get both the lower 1-sided and the upper 1-sided when sides = 1.
%
% 010129 tdr created from interval_est_r and prob_ci to simply input parameters
% 010315 tdr added method options > 2 and verbose.
% 010326 tdr added x=0 fix for Method 5
% 010412 tdr added method to verbose output
% 030110 tdr added warnings for extremes x's and alpha's
% 031223 tdr added test for NaN in inputs

function metrics = rate_ci(x,A,alpha,method, verbose)

% ------------------------------------------------------------
% start checking inputs

if nargin == 4, 
    verbose = 0;
end

if nargin == 3, 
    verbose = 0;
    method = 2;
end

if (nargin ~= 3) & (nargin ~= 4) & (nargin ~= 5), 
    error('Requires 3, 4, or 5 input arguments x, A, alpha, method(default=2), verbose(default=0)');
end
 
% inputs must all be scalars
if (max(max([size(x); size(A); size(alpha)])) ~= 1)
    error('Non-scalar input');   
end;

if isnan(x) | isnan(A) | isnan(alpha)
    warning('NaN input')
    metrics = [NaN, NaN, NaN];
    return
end;
 
% x must be integer
if (round(x) ~= x)
    x = round(x);
    warning('Non-integer input x');   
end;

% A must be > 0
if (A <= 0),
   metrics = [ NaN NaN NaN];
   warning('A <= 0');
   return;
end;

% x must be >= 0
if ( x < 0),
   metrics = [ NaN NaN NaN];
   warning('x < 0');
   return;
end;

% results may be inaccurate for x too large or alpha too small
if ( x > 1e6), warning('x > 1e6, results may not be accurate.'); end;
if ( alpha < 1e-5), warning('alpha < 1e-5, results may not be accurate.'); end;

% alpha must be > 0.0 and < 1.0
if ( alpha < 0 | alpha > 1),
   metrics = [ NaN NaN NaN];
   warning('alpha < 0 or alpha > 1');
   return;
end;

% end checking inputs
% ------------------------------------------------------------

% call interval estimator with best method
tic;
switch method
case 1,
   ci = interval_est_r(x,A,alpha,'cs1_1s');
case 2,
   ci = interval_est_r(x,A,alpha,'ml');
case 3,
   ci = interval_est_r(x,A,alpha,'cs1');
case 4,
   ci = interval_est_r(x,A,alpha/2,'cs1_1s');
case 5,
   [lambda ci_tmp] = poissfit(x,alpha);
   ci = [lambda ci_tmp(1) ci_tmp(2)]/A;
   if (x == 0) ci(2) = 0; end;
case 6,
   ci = interval_est_r(x,A,alpha,'na');
otherwise
   error('Not a valid method: 1 (1-sided), 2 (min length), 3 (symm.), 4 (equal tail), 5 (MatLab-poissfit), 6 (Normal Approx)');
end;
rt = toc;

if verbose
    max_lambda = max(1000, x*1000);
    length = ci(3)-ci(2);
    lower_tail = integrate_poisspdf(x,0,A*ci(2));
    upper_tail = integrate_poisspdf(x,A*ci(3),max_lambda);
    if (method == 1)
        actual_alpha = (lower_tail + upper_tail)/2;
    else
        actual_alpha = lower_tail + upper_tail;
    end;
    if (abs(actual_alpha - alpha) > 0.00005) % close_enough is 0.00001 throughout, but spec is 0.0001.
        warning('Interval not to spec: abs(desired_alpha - actual_alpha) < 0.00005)');
        warning_stats = [alpha actual_alpha alpha-actual_alpha]
    end;
    disp('r_hat, Lower CI Bound, Upper CI Bound, x, A, Desired alpha, Method, Length, Lower Tail, Upper Tail, Actual alpha, Delta alpha, Run Time')
    metrics = [ci x A alpha method length lower_tail upper_tail actual_alpha (alpha - actual_alpha) rt];
    disp(sprintf('%8.4g, %8.4g, %8.4g, %d, %8.4g, %8.6g, %d, %8.4g, %8.6g, %8.6g, %8.6g, %8.6g, %8.2g',metrics));
else
    metrics = ci;
end;


