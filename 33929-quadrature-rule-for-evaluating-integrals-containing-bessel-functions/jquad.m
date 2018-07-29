function [I err] = jquad(funfcn,v,h,N)
% Numerically evaluates integrals of the following form
%      /+inf
% I = | f(x).*besselj(v,x)dx 
%     /0
% INPUT:
% funfcn: function handle corresponding to f(x).
% v: the order of the bessel function.
% h: the step size in the summation process.
% N: total number of nodes.
%
% OUTPUT:
% I: Integration result.
% err: size of the last term in the summation
% 
% Based on Ogata's method,
% [1] H. Ogata, “A Numerical Integration Formula Based on the Bessel Functions,” 
%  Publications of the Research Institute for Mathematical Sciences, vol. 41, no. 4, pp. 949–970, 2005.
% By AmirNader Askarpour, NOV 2011.

% checking input args
f = fcnchk(funfcn);
if nargin < 2 || isempty(v), v = 0; end;
if nargin < 3 || isempty(h), h = 1.e-1; end;
if nargin < 4 || isempty(N), N = 50; end;
if ~isscalar(v)
    error(message('jquad:scalarLimits'));
elseif v<=-1
    error(message('jquad:scalarLimits'));
end

% calculating zeros of Bessel function
% this function can be found on the MathWorks file exchange
xi_vk = zerobess('J',v,N)/pi;

% weights
w_vk = bessely(v,pi*xi_vk)./besselj(v+1,pi*xi_vk);

 
S = pi*w_vk.*f(pi/h*psi(h*xi_vk)).*besselj(v,pi/h*psi(h*xi_vk)).*d_psi(h*xi_vk);

I = sum(S);
err = S(end);
end

function p = psi(t)
p = t.*tanh(pi/2*sinh(t));
end

function q = d_psi(t)
q = (pi*t.*cosh(t)+sinh(pi*sinh(t)))./(1+cosh(pi*sinh(t)));
q(isnan(q)) = 1;
end