% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: interval_est_r.m
% computes confidence interval estimates for rates.
%
% 022400 tdr created
% 031600 tdr created rate version from interval_est_p.m
% 032200 tdr added cs1, cs2, and tl methods.
% 012601 tdr added input checking.
% 012901 tdr added 1-sided CIs for CS1 method
% 031501 tdr added minimum length method
%

function ci = interval_est_r(x,A,alpha,method)

% ------------------------------------------------------------
% start checking inputs

if nargin ~= 4, 
    error('Requires four input arguments (x,A,alpha,method)');
end
 
% inputs must all be scalars
if (max(max([size(x); size(A); size(alpha)])) ~= 1)
    error('Non-scalar input');   
end;

% x must be integer
if (round(x) ~= x)
    x = round(x);
    warning('Non-integer input x');   
end;

% A must be > 0
if (A <= 0),
   ci = [ NaN NaN NaN];
   warning('A <= 0');
   return;
end;

% x must be >= 0
if ( x < 0),
   ci = [ NaN NaN NaN];
   warning('x < 0');
   return;
end;

% alpha must be > 0.0 and < 1.0
if ( alpha < 0 | alpha > 1),
   ci = [ NaN NaN NaN];
   warning('alpha < 0 or alpha > 1');
   return;
end;

% normalize case
if strcmpi(method,'cs1'), method = 'cs1'; end;
if strcmpi(method,'cs1_1s'), method = 'cs1_1s'; end;
if strcmpi(method,'cs2'), method = 'cs2'; end;
if strcmpi(method,'ibp'), method = 'ibp'; end;
%if strcmpi(method,'ibp_1s'), method = 'ibp_1s'; end;
if strcmpi(method,'ml'), method = 'ml'; end;
if strcmpi(method,'nibp'), method = 'nibp'; end;
%if strcmpi(method,'nibp_1s'), method = 'nibp_1s'; end;
if strcmpi(method,'na'), method = 'na'; end;
if strcmpi(method,'tl'), method = 'tl'; end;

% end checking inputs
% ------------------------------------------------------------

switch method
case 'cs1',
   ci = get_r_ci_cs1(x,A,alpha);
case 'cs1_1s',
   ci = get_r_ci_cs1_1s(x,A,alpha);
case 'cs2',
   ci = get_r_ci_cs2(x,A,alpha);
case 'ibp',
   ci = get_r_ci_ibp(x,A,alpha);
case 'ml',
   ci = get_r_ci_ml(x,A,alpha);
case 'na',
   ci = get_r_ci_na(x,A,alpha);
case 'tl',
   ci = get_r_ci_tl(x,A,alpha);
otherwise
   error('Method not recognized. Methods Available: cs1/cs2 - COMPASE Standards, ibp - Integration of Bayes Posterior; ml - minimum length; na - Normal Approximation; tl - Table Lookup');
end;
