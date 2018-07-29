% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_r_ci_ibp.m
% computes confidence interval for a rate estimate using the normal approximation
%  - assumes x is the number of occurrances of an event in area A
%  - finds confidence interval around the estimate for rate R
%  - with confidence level 1 - alpha
%  - method used is based on integrating the Bayesian posterior
%  - finds a symmetrical two-sided interval, unless one side
%    would cross zero or one, in which case the interval is 
%    offset.
%
% This relies upon user routines when using numerical integration method (not recommended):
%  - integrate_poisspdf.m
%  - poisspdf_of_p.m
%  - poisspdf_0ok.m
% and the Stats toolbox (poisspdf.m)
%
% 022300 tdr created
% 022800 tdr changed from numerical integration to CRC recursive soln.
% 030300 tdr re-created a numerical integration method and renamed to nibp.m
% 031600 tdr created poisson version from binomial version
% 031501 tdr adjusted "close_enough" appoach for fixed alpha accuracy

function ci = get_r_ci_ibp(x,A,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,A,alpha)');
end

r_hat=x/A;
lambda_hat = x;
%close_enough = alpha/1000;
close_enough = 1e-5;
convergence_limit = 50;
convergence_count = 0;

%delta_lambda = get_zc(alpha) * sqrt(x); % initial guess based on normal approximation
delta_too_small = 0.0; % lower bound
% find delta_too_big
delta_too_big = max(1000, 1000*x);
delta_lambda = (delta_too_big + delta_too_small)/2;
not_too_big = 1;
while not_too_big
	a = max([0 lambda_hat-delta_too_big]);
	b = lambda_hat + delta_too_big;
	prob = integrate_poisspdf(x,a,b);
    if (1 - prob) >= alpha
        delta_too_big = 2 * delta_too_big;
    else
        not_too_big = 0;
    end;
end;

a = max([0 lambda_hat-delta_lambda]);	
b = lambda_hat + delta_lambda;
prob = integrate_poisspdf(x,a,b);
diff = (1-alpha)-prob;

while ((abs(diff) > close_enough) & (convergence_count < convergence_limit))
   convergence_count = convergence_count+1;
   if diff > 0
      %prob is too small, need to increase delta
      delta_too_small = max([delta_too_small delta_lambda]);
      delta_lambda = (delta_lambda + delta_too_big)/2;
   else
      %prob is too big, need to decrease delta
      delta_too_big = min([delta_too_big delta_lambda]);
      delta_lambda = (delta_too_small + delta_lambda)/2;
   end;
	a = max([0 lambda_hat-delta_lambda]);
	b = lambda_hat + delta_lambda;
	prob = integrate_poisspdf(x,a,b); %this is the numerical integration call
	diff = (1-alpha)-prob;
end;

% Lack confidence that the initial delta_too_big is being set appropriately
% In the mean time, crash if convergence count gets big.
if convergence_count >= convergence_limit,
   error('May not have converged.');
end;

ci=[r_hat max([lambda_hat-delta_lambda 0])/A (lambda_hat+delta_lambda)/A ];
