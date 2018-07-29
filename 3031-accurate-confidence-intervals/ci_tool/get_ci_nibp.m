% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_ci_nibp.m
% computes confidence interval
%  - assumes x is the number of successes in n Bernoulli trials
%  - finds confidence interval around the estimate for p
%  - with confidence level 1 - alpha
%  - method used is based on integrating f(p|x)
%  - finds a symmetrical two-sided interval, unless one side
%    would cross zero or one, in which case the interval is 
%    offset.
%
% This relies upon user routines when using numerical integration method (not recommended):
%  - integrate_binopdf3.m
%  - binopdf_of_p.m
%  - binopdf_01ok.m
% and the Stats toolbox (binopdf.m)
%
% The search typically converges in less than 15 trials
%
% 022300 tdr created
% 022800 tdr changed from numerical integration to CRC recursive soln.
% 030300 tdr re-created a numerical integration method and renamed to nibp.m
% 031201 tdr changed "close_enough" to fixed 0.00001 (10^-5)

function ci = get_ci_nibp(x,n,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,n,alpha)');
end

p_hat=x/n;

%close_enough = alpha/1000;
close_enough = 0.00001;
convergence_limit = 100;
convergence_count = 0;
hit_limit = 0;

delta_p = 0.1; %arbitrary initial guess
delta_too_big = 1.0;
delta_too_small = 0.0;

a = max([0 p_hat-delta_p]);	
b = min([p_hat+delta_p 1]);
prob = (n+1)*integrate_binopdf(x,n,a,b);
diff = (1-alpha)-prob;

while ((abs(diff) > close_enough) & (convergence_count < convergence_limit))
   convergence_count = convergence_count+1;
   if diff > 0
      %prob is too small, need to increase delta
      delta_too_small = max([delta_too_small delta_p]);
      delta_p = (delta_p + delta_too_big)/2;
   else
      %prob is too big, need to decrease delta
      delta_too_big = min([delta_too_big delta_p]);
      delta_p = (delta_too_small + delta_p)/2;
   end;
	a = max([0 p_hat-delta_p]);	
	b = min([p_hat+delta_p 1]);
	prob = (n+1)*integrate_binopdf(x,n,a,b); %this is the numerical integration call
	diff = (1-alpha)-prob;
end;

if (convergence_count >= convergence_limit) hit_limit = 1; end;
if hit_limit warning('method ''nibp'' convergence limit reached - results may not be accurate.'); end;

ci=[p_hat max([p_hat-delta_p 0]) min([p_hat+delta_p 1])];

