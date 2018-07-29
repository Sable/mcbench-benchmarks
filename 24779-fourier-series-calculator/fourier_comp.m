function coeff = fourier_comp(func,m,L)
%FOURIER_COMP Numerically evaluate Fourier series coefficient.
% coeff = fourier_comp(func,m,L) tries to approximate the function func
% from -L to L with m term Fourier series using quad (MATLAB functions).
% func is a function handle, should accept a vector argument x and return a
% vector result y
% This function return a structure with these fields:
% coeff.a0
% coeff.an
% coeff.bn
% The Fourier series for function f(x) is given below.
%                       inf 
%                      -----
%                      \
%        f(x) = a0/2 +  \  an * sin(n*pi*x/L) + bn * con(n*pi*x/L) 
%                       /
%                      /
%                      -----
%                      n = 1
% 
%   Example:
% 
%   f = @(x)x.*cos(x);
%   coeff = fourier_comp(f,3,pi)
%     coeff = 
%     a0: 0
%     an: [-0.5000 1.3333 -0.7500]
%     bn: [1.4136e-016 0 7.0679e-017]
% 
%   See also
%   fourier_gui
% 
% Author: Amin Bashi
% Created: Jul 2009
% Copyright 2009

% func must be the function handle

for n = 1:m
    an(n) = quad(@fa,-L,L)/L;
    bn(n) = quad(@fb,-L,L)/L;
end
a0 = quad(func,-L,L)/L;
coeff.a0 = a0;
coeff.an = an;
coeff.bn = bn;
    function y = fa(t)
        y = func(t).*sin(n*pi*t/L);
    end
    function y = fb(t)
        y = func(t).*cos(n*pi*t/L);
    end
end