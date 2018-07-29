% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: test_rate_diff.m
%
% use: run "test_rate_diff" and then examine "test_rate_diff_results.csv" in the work folder and 
%      compare it to the "test_rate_diff_results_reference.csv" distributed with the code.
%      Failure to run or significant differences in results may indicate installation problems.
%
% change log:
%   030106 tdr created
%
% function y = rate_diff(x1,A1,x2,A2,delta)
% x - number of observed false alarms
% A - area searched
% delta - amount of difference in the rates
% y - Pr ( r1 - r2 >= delta), where r1_hat = x1/A1 and r2_hat = x2/A2

function test_rate_diff

xs = [0 1 30 100 1e6];
As = [0.1 1 1e6];
deltas = [-5 0 0.1 1 10];

fid = fopen('test_rate_diff_results.csv','w');
fprintf(fid,'%s\n','delta, A1, A2, x1, x2, r1_hat, r2_hat, Pr(r1 - r2 >= delta), r1 - r2 - delta');

for delta = deltas
   for A1 = As
      for A2 = As
         for x1 = xs
            for x2 = xs
               r1 = x1/A1; r2 = x2/A2;
               result_array = [delta A1 A2 x1 x2 r1 r2 rate_diff(x1,A1,x2,A2,delta) r1-r2-delta];
               fprintf(fid,'%8.6f, %10.5f, %10.5f, %d, %d, %8.6f, %8.6f, %12.10f, %12.6f\n',result_array);
            end;
         end;
      end;
   end;
end;

fclose(fid);
