% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: binopdf_of_p.m
% Used when you want to integrate a binomial pdf with 
% respect to p (i.e., x has to be the first argument).
%
% 022300 tdr created
% 030400 tdr replaced global variable approach to getting x and n to binopdf.
% 032200 tdr replaced for loop with vector variable in call to binopdf.

function y = binopdf_of_p(p, x, n)

if nargin ~= 3, 
    error('Requires three input arguments (p,x,n)');
end

y = binopdf_01ok(x,n,p);



