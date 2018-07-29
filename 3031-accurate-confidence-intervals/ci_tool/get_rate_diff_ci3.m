% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_rate_diff_ci3.m
% computes confidence interval
%  - assumes x's are the number of successes in n Bernoulli trials
%  - finds confidence interval around the estimate for r1-r2
%  - with confidence level 1 - alpha
%  - finds a symmetrical two-sided interval, unless one side
%    would cross zero or one, in which case the interval is 
%    offset.

% 030113 tdr created

function ci = get_rate_diff_ci3(x1,A1,x2,A2,alpha,method,verbose)
% balanced width

r1_hat = x1/A1; r2_hat = x2/A2; delta_r_hat = r1_hat - r2_hat;

tolerance = 1e-6;
max_count = 50;
count = 0;

%set limits on search for width
width_too_small = 0; width_too_big = 1e12;

%check that width_too_big is indeed too big
a = delta_r_hat - width_too_big; b = delta_r_hat + width_too_big; 
lower_tail_contribution = 1- rate_diff(x1,A1,x2,A2,a);  upper_tail_contribution = rate_diff(x1,A1,x2,A2,b);
alpha_width_too_big = lower_tail_contribution + upper_tail_contribution;
if alpha_width_too_big > alpha, error('Failure to set upper bound on CI width'); end;

% set initial guess and corresponding alpha
width_guess = (width_too_big + width_too_small)/2;
a = delta_r_hat - width_guess; b = delta_r_hat + width_guess; 
lower_tail_contribution = 1- rate_diff(x1,A1,x2,A2,a);  upper_tail_contribution = rate_diff(x1,A1,x2,A2,b);
alpha_guess = lower_tail_contribution + upper_tail_contribution;

% binary search
while (abs(alpha_guess - alpha) > tolerance & (count < max_count))
    if (alpha_guess < alpha)
        width_too_big = width_guess;
        width_guess = (width_too_small + width_guess)/2;
    else
        width_too_small = width_guess;
        width_guess = (width_too_big + width_guess)/2;
    end;
    count = count+1;
    a = delta_r_hat - width_guess;     b = delta_r_hat + width_guess; 
    lower_tail_contribution = 1- rate_diff(x1,A1,x2,A2,a);  upper_tail_contribution = rate_diff(x1,A1,x2,A2,b);
    alpha_guess = lower_tail_contribution + upper_tail_contribution;
end;

ci = [delta_r_hat a b];

