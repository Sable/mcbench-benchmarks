% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: test_rate_ci.m
%
% use: run "test_rate_ci" and then examine "test_rate_ci_results.csv" in the work folder and 
%      compare it to the "test_rate_ci_results_reference.csv" distributed with the code.
%      Failure to run or significant differences in results may indicate installation problems.
%
% change log:
%   000408 tdr created
%   010412 tdr updated for rate_ci.m
%   030106 tdr updated comments

function test_rate_ci

methods = [1 2 3 4 5 6];
alphas = [1e-4 1e-2 0.9];
As = [1.0];
xs = [0 1 30 1000 1e6];

fid = fopen('test_rate_ci_results.csv','w');
fprintf(fid,'%s\n','r_hat, Lower CI Bound, Upper CI Bound, x, A, Desired alpha, Method, Length, Lower Tail, Upper Tail, Actual alpha, Delta alpha, Run Time');

warning off;

for method = methods
   for alpha = alphas
      for A = As
      	for x = xs
            ci = rate_ci(x,A,alpha,method,1);
            fprintf(fid,' %10.5f,  %10.5f, %10.5f, %d, %10.5f, %8.6f, %d, %10.5f, %8.6f, %8.6f, %8.6f, %8.6f, %6.2f\n',ci);
			end;
		end;
   end;
end;

warning on;
fclose(fid);
