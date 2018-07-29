function a = sym2polys(p,x)

%Sym2Polys  Extract the coefficients of a symbolic polynomial.
%           This function is an extension of the Matlab SYM2POLY and COEFFS
%           functions in that it allows the coefficients to be symbolic and 
%           returns the full coefficient vector including the zero coefficients.
%
%Usage: c = sym2polys(p,x)
%       where p is the (multi) symbolic polynomial and x is the
%       independent variable. If x is not specified then the variable
%       alphabetically closest to x is used as the independent variable.
%
%Example:    If p = a*b*x^3 + b*c*x + c*d
%            then sym2polys(p) returns [a*b, 0, b*c, c*d]
%            whereas sym2polys(p,'b') returns [a*x^3+c*x, c*d]
%            Note that coeffs(p,x) returns [c*d, b*c, a*b]

%see also: sym2poly, coeffs

% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% September 2, 2004

if nargin == 1, x = findsym(p,1); end

[c,t] = coeffs(p,x);
i = sym2poly(sort(sum(t*(1:numel(t)).')));
a = sym(i);
a(i>0) = c(i(i>0));

if isempty(findsym(a)), a = double(a); end