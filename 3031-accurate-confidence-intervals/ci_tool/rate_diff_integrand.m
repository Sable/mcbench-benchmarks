% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: rate_diff_integrand.m

% 010507 tdr created from prop version

function y = rate_diff_integrand(x,a1,b1,A1,a2,b2,A2,delta)

y = ((A1/A2) * gampdf(x*(A1/A2),a1,b1)) .* gamcdf(x-delta*A2,a2,b2);

%tmp ......

%y2 = gampdf(x*(A1/A2),a1,b1);
%y3 = gamcdf(x-delta*A2,a2,b2);

%clf;
%semilogy(x,y,'k');
%hold;
%title(['A1= ',num2str(A1),' ','A2= ',num2str(A2),' ','lb= ',num2str(x(1)),' ','ub= ',num2str(x(max(size(x))))]);
%semilogy(x,y2,'--r');
%semilogy(x,y3,'--b');
%hold off;

