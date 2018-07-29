% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_prop_diff_ci3.m
% computes confidence interval
%  - assumes x's are the number of successes in n Bernoulli trials
%  - finds confidence interval around the estimate for p1-p2
%  - with confidence level 1 - alpha
%  - finds a symmetrical two-sided interval, unless one side
%    would cross zero or one, in which case the interval is 
%    offset.

% 030113 tdr created

function ci = get_prop_diff_ci3(x1,n1,x2,n2,alpha,method,verbose)
% balanced width

p1_hat = x1/n1; p2_hat = x2/n2; delta_p_hat = p1_hat - p2_hat;
width_too_small = 0; width_too_big = 1+abs(delta_p_hat);

tolerance = 1e-6;
max_count = 50;
count = 0;
width_guess = (width_too_big + width_too_small)/2;
% a is lower limit of ci, b is upper limit
a = max(-1, delta_p_hat - width_guess); b = min(1, delta_p_hat + width_guess); 

% lower tail contribution to alpha is 1-Pr{delta_p >= a}
% upper tail contribution to alpha is Pr{delta_p >= b}
lower_tail_contribution = 1- prop_diff(x1,n1,x2,n2,a);  upper_tail_contribution = prop_diff(x1,n1,x2,n2,b);
alpha_guess = lower_tail_contribution + upper_tail_contribution;

while (abs(alpha_guess - alpha) > tolerance & (count < max_count))
    if (alpha_guess < alpha)
        width_too_big = width_guess;
        width_guess = (width_too_small + width_guess)/2;
    else
        width_too_small = width_guess;
        width_guess = (width_too_big + width_guess)/2;
    end;
    count = count+1;
    a = max(-1, delta_p_hat - width_guess);     b = min(1, delta_p_hat + width_guess); 
    lower_tail_contribution = 1- prop_diff(x1,n1,x2,n2,a);  upper_tail_contribution = prop_diff(x1,n1,x2,n2,b);
    alpha_guess = lower_tail_contribution + upper_tail_contribution;
end;

ci = [delta_p_hat a b];
