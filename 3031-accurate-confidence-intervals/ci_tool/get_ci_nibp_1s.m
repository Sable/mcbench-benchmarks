% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_ci_nibp_1s.m
% computes confidence interval
%  - x is the number of successes in n Bernoulli trials
%  - finds confidence interval around the estimate for p
%  - with confidence level 1 - alpha
%  - method used is based on integrating f(p|x)
%  - finds two one-sided intervals
%
% This is recursive in n, so the stack gets too large and 
% crashes MatLab if n is too large. n > 5960 crashes my PC.
%
% The search typically converges in less than 15 trials
%
% 082500 tdr created from get_ci_ribp_1s.m
% 012901 tdr we have been forcing the lower one-sided interval to be less than p_hat
%   and the upper to be greater.  This isn't necessarily the case.  Fixed that.
% 031201 tdr changed "close_enough" to fixed 0.00001 (10^-5)

function ci = get_ci_nibp_1s(x,n,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,n,alpha)');
end;

p_hat=x/n;

%close_enough = alpha/1000;
close_enough = 0.00001;
convergence_limit = 100;
convergence_count = 0;

%---------------------------------------------
% start lower one-sided CI

b_too_small = 0;
b_too_big = 1;
a = 0;	
b = p_hat;
prob = (n+1)*integrate_binopdf(x,n,a,b);
diff = alpha-prob;

while ((abs(diff) > close_enough) & (convergence_count < convergence_limit))
   	convergence_count = convergence_count+1;
   	if diff > 0
      	%prob is too small, need to increase b
      	b_too_small = max(b_too_small, b);
   	else
      	%prob is too big, need to decrease b
      	b_too_big = min(b_too_big, b);
   	end;
    b = (b_too_small + b_too_big)/2;
	prob = (n+1)*integrate_binopdf(x,n,a,b);
	diff = alpha-prob;
end;

if b < 0, error('b<0'); end;

one_sided_lower_limit = b;

% end lower one-sided CI
%---------------------------------------------
% start upper one-sided CI

b_too_small = 0;
b_too_big = 1;
a = 0;	
b = p_hat;
prob = (n+1)*integrate_binopdf(x,n,a,b);
diff = (1-alpha)-prob;

while ((abs(diff) > close_enough) & (convergence_count < convergence_limit))
   	convergence_count = convergence_count+1;
   	if diff > 0
      	%prob is too small, need to increase b
      	b_too_small = max(b_too_small, b);
   	else
      	%prob is too big, need to decrease b
      	b_too_big = min(b_too_big, b);
   	end;
    b = (b_too_small + b_too_big)/2;
	prob = (n+1)*integrate_binopdf(x,n,a,b);
	diff = (1-alpha)-prob;
end;

if b < 0, error('b<0'); end;

one_sided_upper_limit = b;

% end lower one-sided CI
%---------------------------------------------

ci=[p_hat one_sided_lower_limit one_sided_upper_limit];
