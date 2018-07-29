% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: test_prop_ci.m
%
% use: run "test_prop_ci" and then examine "test_prop_ci_results.csv" in the work folder and 
%      compare it to the "test_prop_ci_results_reference.csv" distributed with the code.
%      Failure to run or significant differences in results may indicate installation problems.
%
% change log:
%   000408 tdr created
%   010411 tdr modified to run prop_ci.m related tests
%   030106 tdr adjusted comments

function test_prop_ci

methods = [1 2 3 4 5 6];
alphas = [1e-4 1e-2 0.9];
ns = [1 30 100 1000 1e5];

fid = fopen('test_prop_ci_results.csv','w');
fprintf(fid,'%s\n','p_hat, Lower CI Bound, Upper CI Bound, x, n, Desired alpha, Method, Length, Lower Tail, Upper Tail, Actual alpha, Delta alpha, Run Time');

warning off;
tic;

for method = methods
   for alpha = alphas
      for n = ns
         if n < 10
            xs = [0 1 round(n/2) n];
         else
            xs = [0 1 round(n/3) round(n/2) n-1 n];
         end;
         for x = xs
            ci = prop_ci(x,n,alpha,method,1);
            fprintf(fid,'%8.6f, %8.6f, %8.6f, %d, %d, %8.6f, %d, %8.6f, %8.6f, %8.6f, %8.6f, %8.6f, %8.2f\n',ci);
			end;
		end;
   end;
end;

toc
warning on;
fclose(fid);
