% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: test_prop_diff_ci.m
%
% use: run "test_prop_diff_ci" and then examine "test_prop_diff_ci_results.csv" in the work folder and 
%      compare it to the "test_prop_diff_ci_results_reference.csv" distributed with the code.
%      Failure to run or significant differences in results may indicate installation problems.
%
% change log:
%   030114 tdr created from test_prop_ci.m

function test_prop_diff_ci

methods = [1 3 4 5 6];
alphas = [1e-4 1e-2 0.9];
ns = [1 30 1e5];

fid = fopen('test_prop_diff_ci_results.csv','w');
fprintf(fid,'%s\n','delta_p_hat, Lower CI Bound, Upper CI Bound, x1, n1, x2, n2, Desired alpha, Method, Length, Lower Tail, Upper Tail, Actual alpha, Delta alpha, Run Time');

warning off;

for method = methods
   for alpha = alphas
      for n1 = ns
         if n1 < 5
            x1s = [0];
         else
            x1s = [0 1 round(n1/3)];
         end;
         for n2 = ns
            if n2 < 5
                x2s = [n2];
            else
                x2s = [0 1 round(n2/2) n2];
            end;
            for x1 = x1s
                for x2 = x2s
                    ci = prop_diff_ci(x1,n1,x2,n2,alpha,method,1);
                    fprintf(fid,'%8.6g, %8.6g, %8.6g, %d, %d, %d, %d, %8.6g, %d, %8.6g, %8.6g, %8.6g, %8.6g, %8.6g, %8.2g\n',ci);
                end;
			end;
		 end;
     end;
   end;
end;

warning on;
fclose(fid);
