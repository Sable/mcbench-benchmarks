% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: test_rate_diff_ci.m
%
% use: run "test_rate_diff_ci" and then examine "test_rate_diff_ci_results.csv" in the work folder and 
%      compare it to the "test_rate_diff_ci_results_reference.csv" distributed with the code.
%      Failure to run or significant differences in results may indicate installation problems.
%
% change log:
%   030114 tdr created from test_rate_ci.m

function test_rate_diff_ci

methods = [1 3 4];
alphas = [1e-4 1e-2 0.9];
A1s = [1.0];
x1s = [0 1 30 1000 1e6];
A2s = [1.0 10.0];
x2s = [0 10 1000];

fid = fopen('test_rate_diff_ci_results.csv','w');
fprintf(fid,'%s\n','delta_r_hat, Lower CI Bound, Upper CI Bound, x1, A1, x2, A2, Desired alpha, Method, Length, Lower Tail, Upper Tail, Actual alpha, Delta alpha, Run Time');

warning off;

for method = methods
   for alpha = alphas
      for A1 = A1s
        for A2 = A2s
      	    for x1 = x1s
      	        for x2 = x2s
                    ci = rate_diff_ci(x1,A1,x2,A2,alpha,method,1);
                    fprintf(fid,' %10.5g,  %10.5g, %10.5g, %d, %10.5g, %d, %10.5g, %8.6g, %d, %10.5g, %8.6g, %8.6g, %8.6g, %8.6g, %6.2g\n',ci);
                end;
            end;
		  end;
	   end;
   end;
end;

warning on;
fclose(fid);
