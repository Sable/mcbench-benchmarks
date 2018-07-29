% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: prop_diff_ci.m

% 030110 tdr created
% 031223 tdr added test for NaN in inputs
% 040203 tdr corrected error found by Steve Walls in check_inputs (was using n in place of n1 when ensuring that we had integers)

function metrics = prop_diff_ci(x1,n1,x2,n2,alpha,method,verbose)

if (nargin ~= 7 & nargin ~= 6 & nargin ~= 5), 
    error('Requires 5, 6, or 7 input arguments (x1,n1,x2,n2,alpha), (x1,n1,x2,n2,alpha,method), or (x1,n1,x2,n2,alpha,method,verbose); default method = 3');
end 
if nargin == 5, method = 3; verbose = 0; end;
if nargin == 6, verbose = 0; end;
inputsOkay = check_inputs(x1,n1,x2,n2,alpha,method,verbose);
if ~inputsOkay
    metrics = [NaN, NaN, NaN];
    return
end;

tic;

% call selected interval estimator method
switch method
case 1, % one-sided CI - note provides both upper and lower one-sided CIs
    ci = get_prop_diff_ci1(x1,n1,x2,n2,alpha,method,verbose);
case 2, % minimum length CI
    error('Method 2 Not Available - choose Method 1, 3, 4, 5 or 6');
case 3, % symmetrical about estimate, expect when outside range
    ci = get_prop_diff_ci3(x1,n1,x2,n2,alpha,method,verbose);
case 4, % equal tail masses, note - may not enclose estimate
    ci = get_prop_diff_ci1(x1,n1,x2,n2,alpha/2,method,verbose);
case 5, % Using Fagan's application of "exact" method
    ci = get_ci_fagan(x1,n1,x2,n2,alpha,method,verbose);
case 6, % Normal Approximation
    ci = get_ci_rss(x1,n1,x2,n2,alpha,method,verbose);
case 7, % Law of Large Numbers Approximation
    error('Method 7 Not Available - choose Method 1, 3, 4, 5 or 6');
otherwise
   error('Not a valid method: 1 (1-sided), 2 (min length), 3 (symm.), 4 (equal tail), 5 (MatLab-binofit), 6 (Normal Approx)');
end;
rt = toc;

if verbose
    p1_hat = x1/n1; p2_hat = x2/n2; delta_p_hat = p1_hat - p2_hat;
    length = ci(3)-ci(2);
    lower_tail = 1 - prop_diff(x1,n1,x2,n2,ci(2));
    upper_tail = prop_diff(x1,n1,x2,n2,ci(3));
    if (method == 1)
        actual_alpha = (lower_tail + upper_tail)/2;
    else
        actual_alpha = lower_tail + upper_tail;
    end;
    if (abs(actual_alpha - alpha) > 0.00005) % close_enough is 0.00001 throughout, but spec is 0.0005.
        warning('Interval not to spec: abs(desired_alpha - actual_alpha) < 0.00005)');
        warning_stats = [alpha actual_alpha alpha-actual_alpha]
    end;
    disp('p_diff_hat, Lower CI Bound, Upper CI Bound, x1, n1, x2, n2, Desired alpha, Method, Length, Lower Tail, Upper Tail, Actual alpha, Delta alpha, Run Time')
    metrics = [ci x1 n1 x2 n2 alpha method length lower_tail upper_tail actual_alpha (alpha - actual_alpha) rt];
    disp(sprintf('%8.6g, %8.6g, %8.6g, %d, %d, %d, %d, %8.6g, %d, %8.6g, %8.6g, %8.6g, %8.6g, %8.6g, %8.2g',metrics));
else
    metrics = ci;
end;


% ------------------------------------------------------------
% Difference CI based on root sum of squares of individual CI's, see
% Fagan'99 in Computers in Biology and Medicine.

function  ci = get_ci_fagan(x1,n1,x2,n2,alpha,method,verbose);
    ci1 = prop_ci(x1,n1,alpha,method);
    ci2 = prop_ci(x2,n2,alpha,method);
    diff = ci1(1) - ci2(1);    
    correction_factor = 0.18 / max(n1,n2); % see Fagan'99, p.85
    rss_lower = diff - sqrt((ci1(2)-ci1(1))^2 + (ci2(3)-ci2(1))^2);
    rss_upper = diff + sqrt((ci1(3)-ci1(1))^2 + (ci2(2)-ci2(1))^2);
    diff_lower = max((ci1(2)-ci2(3)), (rss_lower - correction_factor));
    diff_upper = min((ci1(3)-ci2(2)), (rss_upper + correction_factor));
    ci = [diff diff_lower diff_upper];

% ------------------------------------------------------------
% Difference CI based on root sum of squares of individual CI's

function  ci = get_ci_rss(x1,n1,x2,n2,alpha,method,verbose);
    ci1 = prop_ci(x1,n1,alpha,method);
    ci2 = prop_ci(x2,n2,alpha,method);
    diff = ci1(1) - ci2(1);    
    rss_lower = diff - sqrt((ci1(2)-ci1(1))^2 + (ci2(3)-ci2(1))^2);
    rss_upper = diff + sqrt((ci1(3)-ci1(1))^2 + (ci2(2)-ci2(1))^2);
    ci = [diff rss_lower rss_upper];

% ------------------------------------------------------------
% start checking inputs
function inputsOkay = check_inputs(x1,n1,x2,n2,alpha,method,verbose)

inputsOkay = 1;

% inputs must all be scalars
if (max(max([size(x1); size(n1); size(x2); size(n2); size(alpha)])) ~= 1)
    error('Non-scalar input');   
end;

if isnan(x1) | isnan(n1) | isnan(x2) | isnan(n2) | isnan(alpha)
    warning('NaN input')
    inputsOkay = 0;
    return
end;

% x and n must be integers
if (round(x1) ~= x1)
    x1 = round(x1);
    warning('Non-integer input x1');   
end;
if (round(x2) ~= x2)
    x2 = round(x2);
    warning('Non-integer input x2');   
end;
if (round(n1) ~= n1)
    n1 = round(n1);
    warning('Non-integer input n1');   
end;
if (round(n2) ~= n2)
    n2 = round(n2);
    warning('Non-integer input n2');   
end;

% n must be > 0
if (n1 <= 0 | n2 <= 0),
   inputsOkay = 0;
   warning('n <= 0');
   return;
end;

% n should be < 10^6
if (n1 > 10^6 | n2 > 10^6),
   warning('n > 10^6, Results may not be accurate.');
end;

% x must be >= 0 and <=n
if ( x1 < 0 | x1 > n1 | x2 < 0 | x2 > n2),
   inputsOkay = 0;
   warning('x < 0 or x > n');
   return;
end;

% alpha must be > 0.0 and < 1.0
if ( alpha < 0 | alpha > 1),
   inputsOkay = 0;
   warning('alpha < 0 or alpha > 1');
   return;
end;

% verbose must be 0 or 1
if ( verbose ~= 0 & verbose ~= 1),
   inputsOkay = 0;
   warning('verbose not zero or one');
   return;
end;
% end checking inputs
% ------------------------------------------------------------

