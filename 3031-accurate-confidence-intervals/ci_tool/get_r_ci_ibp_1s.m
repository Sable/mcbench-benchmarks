% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_r_ci_ibp_1s.m
% computes confidence interval for a rate estimate using the normal approximation
%  - assumes x is the number of occurrances of an event in area A
%  - finds confidence interval around the estimate for rate R
%  - with confidence level 1 - alpha
%  - method used is based on a normal approximation
%  - finds a both the upper and lower one-sided interval
%
% This relies upon user routines when using numerical integration method (not recommended):
%  - integrate_poisspdf.m
%  - poisspdf_of_p.m
%  - poisspdf_0ok.m
% and the Stats toolbox (poisspdf.m)
%
% 012901 tdr created from get_r_ci_ibp.m for one-sided CIs
% 010412 tdr changed close_enough to fixed limit.

function ci = get_r_ci_ibp(x,A,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,A,alpha)');
end

r_hat=x/A;
lambda_hat = x;
%close_enough = alpha/1000;
close_enough = 1e-5;
convergence_limit = 50;
sigma_hat = sqrt(lambda_hat); %estimated std dev

%---------------------------------------------------
% start lower one-sided CI

convergence_count = 0;

a = 0;
b_too_big = lambda_hat + max(100, lambda_hat + 10*sigma_hat); % upper bound
b_too_small = 0.0; % lower bound

b = (b_too_big - b_too_small)/2;
prob = integrate_poisspdf(x,a,b);
diff = alpha-prob;

while ((abs(diff) > close_enough) & (convergence_count < convergence_limit))
   convergence_count = convergence_count+1;
   if diff > 0
      %prob is too small, need to increase b
      b_too_small = max([b_too_small b]);
      b = (b + b_too_big)/2;
   else
      %prob is too big, need to decrease b
      b_too_big = min([b_too_big b]);
      b = (b_too_small + b)/2;
   end;
	prob = integrate_poisspdf(x,a,b); %this is the numerical integration call
	diff = alpha-prob;
end;

% Lack confidence that the initial b_too_big is being set appropriately
% In the mean time, crash if convergence count gets big.
if convergence_count >= convergence_limit,
   error('May not have converged.');
end;

if b < 0, error('b<0'); end;

one_sided_lower_limit = b / A;

% end lower one-sided CI
%---------------------------------------------------
% start upper one-sided CI

convergence_count = 0;

a = 0;
b_too_big = lambda_hat + max(100, lambda_hat + 10*sigma_hat); % upper bound
b_too_small = 0.0; % lower bound

b = (b_too_big - b_too_small)/2;
prob = integrate_poisspdf(x,a,b);
diff = (1-alpha)-prob;

while ((abs(diff) > close_enough) & (convergence_count < convergence_limit))
   convergence_count = convergence_count+1;
   if diff > 0
      %prob is too small, need to increase b
      b_too_small = max([b_too_small b]);
      b = (b + b_too_big)/2;
   else
      %prob is too big, need to decrease b
      b_too_big = min([b_too_big b]);
      b = (b_too_small + b)/2;
   end;
	prob = integrate_poisspdf(x,a,b); %this is the numerical integration call
	diff = (1-alpha)-prob;
end;

% Lack confidence that the initial b_too_big is being set appropriately
% In the mean time, crash if convergence count gets big.
if convergence_count >= convergence_limit,
   error('May not have converged.');
end;

if b < 0, error('b<0'); end;

one_sided_upper_limit =  b / A;

% end upper one-sided CI
%---------------------------------------------------

ci=[r_hat one_sided_lower_limit one_sided_upper_limit];
