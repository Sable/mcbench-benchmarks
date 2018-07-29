% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: test_prop_diff.m
%
% use: run "test_prop_diff" and then examine "test_prop_diff_results.csv" in the work folder and 
%      compare it to the "test_prop_diff_results_reference.csv" distributed with the code.
%      Failure to run or significant differences in results may indicate installation problems.
%
% change log:
%   030106 tdr created
%
% function y = prop_diff(x1,n1,x2,n2,delta)
% x - number of positive events
% n - number of trials
% delta - the difference of interest
% y - Pr (p1 - p2 >= delta), where p1_hat = x1/n1 and p2_hat = x2/n2

function test_prop_diff

n1s = [1 30 100 1e5];
n2s = n1s;
deltas = [-0.5 0 1e-2 0.9];

fid = fopen('test_prop_diff_results.csv','w');
fprintf(fid,'%s\n','delta, n1, n2, x1, x2, p1_hat, p2_hat, Pr(p1 - p2 >= delta)');

for delta = deltas
   for n1 = n1s
      if n1 < 10
         x1s = [0 1 round(n1/2) n1];
      else
         x1s = [0 1 round(n1/3) round(n1/2) n1-1 n1];
      end;
      for n2 = n2s
         if n2 < 10
            x2s = [0 1 round(n2/2) n2];
         else
            x2s = [0 1 round(n2/3) round(n2/2) n2-1 n2];
         end;
         for x1 = x1s
            for x2 = x2s
               result_array = [delta n1 n2 x1 x2 x1/n1 x2/n2 prop_diff(x1,n1,x2,n2,delta)];
               fprintf(fid,'%8.6f, %d, %d, %d, %d, %8.6f, %8.6f, %8.6f\n',result_array);
		    end;
         end;
      end;
   end;
end;

fclose(fid);
