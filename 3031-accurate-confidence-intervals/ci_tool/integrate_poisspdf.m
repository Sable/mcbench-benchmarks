% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% integrate_poisspdf.m
% integrates a poisson pdf with respect to lambda from a to b
%
% 022300 tdr created
% 030400 tdr replaced global variable approach to getting x and n to binopdf.
% 030600 tdr added adjustments to a and b to help quad8 converge quickly.
% 			quad8 has trouble with long stretches of near-zero values
% 			so we try to bound the interval to avoid these regions
% 031600 tdr created integrate_poisspdf.m from integrate_binopdf.m
% 012901 tdr changed quad8 to quadl per MatLab 6 recommendation.  Turned off warnings
%   for quadl call because it thinks intervals starting at zero or ending at one 
%   involve singularities and generates a warning, although accuracy is okay.
% 031501 tdr changed thres2 from 0.001 to 1.

function y = integrate_poisspdf(x,a,b)

if nargin ~= 3, 
    error('Requires three input arguments (x,a,b)');
end

TRACE = 0;
lambda_hat = x;
thres = 1e-6*poisspdf_0ok(x,x); % pdf values less than this are assumed to be negligible.
thres2 = 1; % resolution of adjustments to a and b.
tiny_a = (poisspdf_0ok(x,a) < thres);
tiny_b = (poisspdf_0ok(x,b) < thres);

if tiny_a & tiny_b & (a > lambda_hat | b < lambda_hat),
	%both a and b give results near zero, with no non-zero values between them
   y = 0;
   return
end;

% defaults
new_a = a;
new_b = b;

if tiny_a,
	% a needs to be increased, but not past b or lambda_hat
	ll = a; ul = min(b, lambda_hat);
   while (abs(ll - ul) > thres2),
   	test = (ll + ul)/2;
      if poisspdf_0ok(x,test) < thres,
      	ll = test;
      else
      	ul = test;
      end;
   end;
	new_a = ll;   
end;

if tiny_b,
	% b needs to be decreased, but not past a or lambda_hat
	ll = max(a, lambda_hat); ul = b;
   while (abs(ll - ul) > thres2),
   	test = (ll + ul)/2;
      if poisspdf_0ok(x,test) < thres,
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
warning off; 
y=quadl('poisspdf_of_lambda',new_a,new_b,[],TRACE,x);
warning on;
