% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: poisspdf_of_lambda.m
% Used when you want to integrate a poisson pdf with 
% respect to lambda.
%
% 022300 tdr created
% 030400 tdr replaced global variable approach to getting x and n to binopdf.
% 031600 tdr converted from binopdf_of_p.m to poisson dist.
% 032200 tdr replaced for loop with vector argument.

function y = poisspdf_of_lambda(lambda, x)

if nargin ~= 2, 
    error('Requires two input arguments (lambda,x)');
end

y = poisspdf_0ok(x,lambda);


