% ------------------------------------------------------------------- %
% Matlab files listed in Appendix B of the following book by          %
% Xin-She Yang, Mathematical Modelling for Earth Sciences,            %
%               Dunedin Academic Presss, Edinburgh, UK, (2008).       %
% http://www.dunedinacademicpress.co.uk/ViewReviews.php?id=100        %
% ------------------------------------------------------------------- %

% ------------------------------------------------------------------- %
% Finding roots of f(x)=0 via the Newton's iteration method
% Programmed by Xin-She Yang (Cambridge University)
% Usage: Newton(function_str); E.g. Newton('x^5-pi');
% [Notes: Since the initial guess is random, so in case 
%  of multiple roots, only a single root will be given.]
% ------------------------------------------------------------------- %

function [root]=Newton(fstr)
format long;
% Default function and values if no input
if nargin<1, 
   help Newton.m; 
   fstr='x^5-pi';   
end
% Tolerance (to the tenth decimal place)
   delta=10^(-10);
% Converting the input fstr to a function f(x)
f=vectorize(inline(fstr));
% Defining x as the independent variable
syms x;
% Find the f'(x) from f(x) using diff 
fprime=vectorize(inline(char(diff(f(x),x))));
% Initial random guess
xn=randn;    deltax=1;
% Iteration until the prescribed accuracy 
while (deltax>delta) 
    root=xn-f(xn)/fprime(xn);
    deltax=abs(root-xn);
    xn=root;
end
disp(strcat(fstr, ' has a root'));
root

    
