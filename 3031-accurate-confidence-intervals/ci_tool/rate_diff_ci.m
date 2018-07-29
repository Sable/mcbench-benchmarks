% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: rate_diff_ci.m

% 030110 tdr created
% 031223 tdr added test for NaN in inputs

function metrics = rate_diff_ci(x1,A1,x2,A2,alpha,method,verbose)

if (nargin ~= 7 & nargin ~= 6 & nargin ~= 5), 
    error('Requires 5, 6, or 7 input arguments (x1,A1,x2,A2,alpha), (x1,A1,x2,A2,alpha,method), or (x1,A1,x2,A2,alpha,method,verbose); default method = 3');
end
if nargin == 5, method = 3; verbose = 0; end;
if nargin == 6, verbose = 0; end;
inputsOkay = check_inputs(x1,A1,x2,A2,alpha,method,verbose);
if ~inputsOkay
    metrics = [NaN, NaN, NaN];
    return
end;

tic;

% call selected interval estimator method
switch method
case 1, % one-sided CI - note provides both upper and lower one-sided CIs
    ci = get_rate_diff_ci1(x1,A1,x2,A2,alpha,method,verbose);
case 2, % minimum length CI
    error('Method 2 Not Available - choose Method 1, 3 or 4');
case 3, % symmetrical about estimate, expect when outside range
    ci = get_rate_diff_ci3(x1,A1,x2,A2,alpha,method,verbose);
case 4, % equal tail masses, note - may not enclose estimate
    ci = get_rate_diff_ci1(x1,A1,x2,A2,alpha/2,method,verbose);
case 5, % MatLab's binofit.
    error('Method 5 Not Available - choose Method 1, 3 or 4, see Fagan''99 for exact approach');
case 6, % Normal Approximation
    error('Method 6 Not Available - choose Method 1, 3 or 4');
case 7, % Law of Large Numbers Approximation
    error('Method 7 Not Available - choose Method 1, 3 or 4');
otherwise
   error('Not a valid method: 1 (1-sided), 2 (min length), 3 (symm.), 4 (equal tail), 5 (MatLab-binofit), 6 (Normal Approx)');
end;
rt = toc;

if verbose
    r1_hat = x1/A1; r2_hat = x2/A2; delta_r_hat = r1_hat - r2_hat;
    length = ci(3)-ci(2);
    lower_tail = 1 - rate_diff(x1,A1,x2,A2,ci(2));
    upper_tail = rate_diff(x1,A1,x2,A2,ci(3));
    if (method == 1)
        actual_alpha = (lower_tail + upper_tail)/2;
    else
        actual_alpha = lower_tail + upper_tail;
    end;
    if (abs(actual_alpha - alpha) > 0.00005) % close_enough is 0.00001 throughout, but spec is 0.0005.
        warning('Interval not to spec: abs(desired_alpha - actual_alpha) < 0.00005)');
        warning_stats = [alpha actual_alpha alpha-actual_alpha]
    end;
    disp('r_diff_hat, Lower CI Bound, Upper CI Bound, x1, A1, x2, A2, Desired alpha, Method, Length, Lower Tail, Upper Tail, Actual alpha, Delta alpha, Run Time')
    metrics = [ci x1 A1 x2 A2 alpha method length lower_tail upper_tail actual_alpha (alpha - actual_alpha) rt];
    disp(sprintf('%8.4g, %8.4g, %8.4g, %d, %8.4g, %d, %8.4g, %8.6g, %d, %8.4g, %8.6g, %8.6g, %8.6g, %8.6g, %8.2g',metrics));
else
    metrics = ci;
end;


% ------------------------------------------------------------
% start checking inputs
function inputsOkay = check_inputs(x1,A1,x2,A2,alpha,method,verbose)

inputsOkay = 1;

% inputs must all be scalars
if (max(max([size(x1); size(A1); size(x2); size(A2); size(alpha)])) ~= 1)
    error('Non-scalar input');   
end;

% x must be integers
if (round(x1) ~= x1)
    x1 = round(x1);
    warning('Non-integer input x');   
end;
if (round(x2) ~= x2)
    x2 = round(x2);
    warning('Non-integer input x');   
end;

if any(isnan([x1, A1, x2, A2, alpha]));
    warning('NaN input')
    inputsOkay = 0;
    return
end;

% A must be > 0
if (A1 <= 0 | A2 <= 0),
   inputsOkay = 0;
   warning('A <= 0');
   return;
end;

% A should be < 10^6
if (A1 > 10^6 | A2 > 10^6),
   warning('A > 10^6, Results may not be accurate.');
end;

% x must be >= 0
if ( x1 < 0 | x2 < 0 ),
   inputsOkay = 0;
   warning('x < 0');
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

