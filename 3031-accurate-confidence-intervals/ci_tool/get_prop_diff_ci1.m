% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_prop_diff_ci1.m
% one-sided confidence intervals for the difference of proportions

% 030113 tdr created

function ci = get_prop_diff_ci1(x1,n1,x2,n2,alpha,method,verbose)

p1_hat = x1/n1; p2_hat = x2/n2; delta_p_hat = p1_hat - p2_hat;
a = find_lower_limit(x1,n1,x2,n2, alpha);
b = find_upper_limit(x1,n1,x2,n2, alpha);
ci = [delta_p_hat a b];

% ------------------------------------------------------------
% find lower limit

function limit = find_lower_limit(x1,n1,x2,n2,alpha)
% alpha is 1-Pr{delta_p >= a}
p1_hat = x1/n1; p2_hat = x2/n2; delta_p_hat = p1_hat - p2_hat;
too_small = -1; too_big = 1;

tolerance = 1e-6;
max_count = 50;

count = 0;
guess = (too_big + too_small)/2;
alpha_guess = 1- prop_diff(x1,n1,x2,n2,guess);
while (abs(alpha_guess - alpha) > tolerance & (count < max_count))
    if (alpha_guess > alpha)
        too_big = guess;
        guess = (too_small + guess)/2;
    else
        too_small=guess;
        guess = (too_big + guess)/2;
    end;
    count = count+1;
    alpha_guess = 1 - prop_diff(x1,n1,x2,n2,guess);
end;

limit = guess;


% ------------------------------------------------------------
% find upper limit

function limit = find_upper_limit(x1,n1,x2,n2,alpha)
% alpha is Pr{delta_p >= b}
p1_hat = x1/n1; p2_hat = x2/n2; delta_p_hat = p1_hat - p2_hat;
too_small = -1; too_big = 1;

tolerance = 1e-6;
max_count = 50;
count = 0;
guess = (too_big + too_small)/2;
alpha_guess = prop_diff(x1,n1,x2,n2,guess);
while (abs(alpha_guess - alpha) > tolerance & (count < max_count))
    if (alpha_guess < alpha)
        too_big = guess;
        guess = (too_small + guess)/2;
    else
        too_small=guess;
        guess = (too_big + guess)/2;
    end;
    count = count+1;
    alpha_guess = prop_diff(x1,n1,x2,n2,guess);
end;

limit = guess;




