% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: interval_est_p.m
% computes confidence interval estimate of Binomial distribution parameter p.
%
% 022400 tdr created
% 031600 tdr added test for n being zero
% 082500 tdr added one-sided option for CS1, ibp, and nap
% 012601 tdr added tests for out-of-range values in inputs and normalized case of method.
% 031201 tdr added min length ci call

function ci = interval_est_p(x,n,alpha,method)

% ------------------------------------------------------------
% start checking inputs

if nargin ~= 4, 
    error('Requires four input arguments (x,n,alpha,method)');
end
 
% inputs must all be scalars
if (max(max([size(x); size(n); size(alpha)])) ~= 1)
    error('Non-scalar input');   
end;

% x and n must be integers
if (round(x) ~= x)
    x = round(x);
    warning('Non-integer input x');   
end;
if (round(n) ~= n)
    n = round(n);
    warning('Non-integer input n');   
end;

% n must be > 0
if (n <= 0),
   ci = [ NaN NaN NaN];
   warning('n <= 0');
   return;
end;

% n should be < 10^6
if (n > 10^6),
   warning('n > 10^6, Results may not be accurate.');
end;

% x must be >= 0 and <=n
if ( x < 0 | x > n),
   ci = [ NaN NaN NaN];
   warning('x < 0 or x > n');
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
if strcmpi(method,'ibp_1s'), method = 'ibp_1s'; end;
if strcmpi(method,'nibp'), method = 'nibp'; end;
if strcmpi(method,'nibp_1s'), method = 'nibp_1s'; end;
if strcmpi(method,'ribp'), method = 'ribp'; end;
if strcmpi(method,'ribp_1s'), method = 'ribp_1s'; end;
if strcmpi(method,'lln'), method = 'lln'; end;
if strcmpi(method,'llnp'), method = 'llnp'; end;
if strcmpi(method,'ml'), method = 'ml'; end;
if strcmpi(method,'na'), method = 'na'; end;
if strcmpi(method,'nap'), method = 'nap'; end;
if strcmpi(method,'nap_1s'), method = 'nap_1s'; end;

% end checking inputs
% ------------------------------------------------------------

switch method
case 'cs1',
   ci = get_ci_cs1(x,n,alpha);
case 'cs1_1s',
   ci = get_ci_cs1_1s(x,n,alpha);
case 'cs2',
   ci = get_ci_cs2(x,n,alpha);
case 'ibp',
   ci = get_ci_ibp(x,n,alpha);
case 'ibp_1s',
   ci = get_ci_ibp_1s(x,n,alpha);
case 'nibp',
   ci = get_ci_nibp(x,n,alpha);
case 'nibp_1s',
   ci = get_ci_nibp_1s(x,n,alpha);
case 'ribp',
   ci = get_ci_ribp(x,n,alpha);
case 'ribp_1s',
   ci = get_ci_ribp_1s(x,n,alpha);
case 'lln',
   ci = get_ci_lln(x,n,alpha);
case 'llnp',
   ci = get_ci_llnp(x,n,alpha);
case 'ml',
   ci = get_ci_ml(x,n,alpha);
case 'na',
   ci = get_ci_na(x,n,alpha);
case 'nap',
   ci = get_ci_nap(x,n,alpha);
case 'nap_1s',
   ci = get_ci_nap_1s(x,n,alpha);
otherwise
   error('Method not recognized. Methods Available: cs1(_1s)/cs2 - COMPASE Standards, ibp(_1s)/nibp(_1s)/ribp(_1s) - Integration of Bayes Posterior; lln/llnp - Law of Large Numbers; na/nap(_1s) - Normal Approximation');
end;
