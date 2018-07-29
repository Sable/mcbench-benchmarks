% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% integrate_binpdf.m
% integrates a binomial pdf with respect to p from a to b
%
% 000223 tdr created
% 000304 tdr replaced global variable approach to getting x and n to binopdf.
% 000306 tdr added adjustments to a and b to help quad8 converge quickly.
% 			quad8 has trouble with long stretches of near-zero values
% 			so we try to bound the interval to avoid these regions
% 			x/n is the max
% 000316 tdr made thres dependent on max binopdf value.
% 000331 tdr provided a floor for thres, it was NaN for very small pdf values, i.e., very large n.
% 000331 tdr added error check for returning values of NaN or Inf
% 010126 tdr changed quad8 to quadl per recommendation of MatLab 6 runs
% 010312 tdr added adaptive tolerance to integration.
% 030106 tdr adjusted comments

function y = integrate_binopdf(x,n,a,b)

if nargin ~= 4, 
    error('Requires four input arguments (x,n,a,b)');
end

TRACE = 0;
p_hat = x/n;

% pdf values less than this are assumed to be negligible
thres = 1e-20;

thres2 = 0.001; % resolution of adjustments to a and b.
tiny_a = (binopdf_01ok(x,n,a) < thres);
tiny_b = (binopdf_01ok(x,n,b) < thres);

if tiny_a & tiny_b & (a > p_hat | b < p_hat),
	%both a and b give results near zero, with no non-zero values between them
   y = 0;
   return
end;

% defaults
new_a = a;
new_b = b;

if tiny_a,
	% a needs to be increased, but not past b or p_hat
	ll = a; ul = min(b, p_hat);
   while (abs(ll - ul) > thres2),
   	test = (ll + ul)/2;
      if binopdf_01ok(x,n,test) < thres,
      	ll = test;
      else
      	ul = test;
      end;
   end;
	new_a = ll;   
end;

if tiny_b,
	% b needs to be decreased, but not past a or p_hat
	ll = max(a, p_hat); ul = b;
   while (abs(ll - ul) > thres2),
   	test = (ll + ul)/2;
      if binopdf_01ok(x,n,test) < thres,
      	ul = test;
      else
      	ll = test;
      end;
   end;
	new_b = ul;   
end;

% call quad with increased a
%   quadl thinks interval starting at zero or ending at one might involve 
%   a singularity and produces a warning, despite being accurate.
%warning off; 
close_enough = 0.00001;
tolerance = min(1.0e-6, close_enough/(n+1)); 
y=quadl('binopdf_of_p',new_a,new_b,tolerance,TRACE,x,n);
%warning on;

if ~isfinite(y),
   error('quadl returned NaN or Inf');
end;

