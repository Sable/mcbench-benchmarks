% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_rate_diff_ci1.m
% one-sided confidence intervals for the difference of rates

% 030113 tdr created

function ci = get_rate_diff_ci1(x1,A1,x2,A2,alpha,method,verbose)

r1_hat = x1/A1; r2_hat = x2/A2; delta_r_hat = r1_hat - r2_hat;
a = find_lower_limit(x1,A1,x2,A2, alpha);
b = find_upper_limit(x1,A1,x2,A2, alpha);
ci = [delta_r_hat a b];

% ------------------------------------------------------------
% find lower limit

function limit = find_lower_limit(x1,A1,x2,A2,alpha)
% alpha is 1-Pr{delta_r >= a}
r1_hat = x1/A1; r2_hat = x2/A2; delta_r_hat = r1_hat - r2_hat;

% set limits of search
too_big = 1e12; too_small = -1e12;

%check that too_big is indeed too big etc.
alpha_too_big = 1 - rate_diff(x1,A1,x2,A2,too_big);
alpha_too_small = 1 - rate_diff(x1,A1,x2,A2,too_small);
if (alpha_too_big < alpha | alpha_too_small > alpha), error('Failure to set bounds for search'); end;

tolerance = 1e-6;
max_count = 50;
count = 0;

% initial guess for search
guess = (too_big + too_small)/2;
alpha_guess = 1- rate_diff(x1,A1,x2,A2,guess);

% binary search
while (abs(alpha_guess - alpha) > tolerance & (count < max_count))
    if (alpha_guess > alpha)
        too_big = guess;
        guess = (too_small + guess)/2;
    else
        too_small=guess;
        guess = (too_big + guess)/2;
    end;
    count = count+1;
    alpha_guess = 1 - rate_diff(x1,A1,x2,A2,guess);
end;

limit = guess;


% ------------------------------------------------------------
% find upper limit

function limit = find_upper_limit(x1,A1,x2,A2,alpha, bounds)
% alpha is Pr{delta_r >= b}
r1_hat = x1/A1; r2_hat = x2/A2; delta_r_hat = r1_hat - r2_hat;

% set limits for search
too_big = 1e12;  too_small = -1e12;

%check that too_big is indeed too big etc.
alpha_too_big = rate_diff(x1,A1,x2,A2,too_big);
alpha_too_small = rate_diff(x1,A1,x2,A2,too_small);
if (alpha_too_big > alpha | alpha_too_small < alpha), error('Failure to set bounds for search'); end;

tolerance = 1e-6;
max_count = 50;
count = 0;

% initial guess for search
guess = (too_big + too_small)/2;
alpha_guess = rate_diff(x1,A1,x2,A2,guess);

% binary search
while (abs(alpha_guess - alpha) > tolerance & (count < max_count))
    if (alpha_guess < alpha)
        too_big = guess;
        guess = (too_small + guess)/2;
    else
        too_small=guess;
        guess = (too_big + guess)/2;
    end;
    count = count+1;
    alpha_guess = rate_diff(x1,A1,x2,A2,guess);
end;

limit = guess;
