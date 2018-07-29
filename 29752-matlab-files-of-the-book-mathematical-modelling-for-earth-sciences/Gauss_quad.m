% ------------------------------------------------------------------- %
% Matlab files listed in Appendix B of the following book by          %
% Xin-She Yang, Mathematical Modelling for Earth Sciences,            %
%               Dunedin Academic Presss, Edinburgh, UK, (2008).       %
% http://www.dunedinacademicpress.co.uk/ViewReviews.php?id=100        %
% ------------------------------------------------------------------- %

% ------------------------------------------------------------------- %
% Gauss Numerical Integration of I=\int_a^b f(x) dx
% by 7-point Gaussian Quadrature
% Programmed by Xin-She Yang (Cambridge University) @ 2008
% Usage: Gauss_quad(function_str,a,b) 
%   E.g. Gauss_quad('(sin(x)./x).^2',0,pi);
% ------------------------------------------------------------------- %

function [I]=Gauss_quad(fstr,a,b)
format long;
if nargin<3, 
 disp('Usage:Gauss_quad(integrand,a,b)');
 disp('E.g., Gauss_quad(''exp(-x^2)*2/sqrt(pi)'',-1,1);');
end
% Default function and values if no input
if nargin<1, 
   help Gauss_quad.m; 
   fstr='exp(-x^2)*2/sqrt(pi)'; 
   a=-1.0; b=1.0;
end
% Converting the input integrand, fstr, to a function f(x)
f=inline(vectorize(fstr));
% Seven-point integration scheme so zeta_1 to zeta_7 
zeta=[-0.9491079123; -0.7415311855; -0.4058451513; 0.0;  
       0.4058451513; 0.7415311855; 0.9491079123];
% Weighting coefficients
w=[0.1294849661; 0.2797053914; 0.3818300505; 0.4179591836;
   0.3818300505; 0.2797053914; 0.1294849661];
% Index for the seven points 
Index=1:7; 
Iunit=sum(w(Index).*f((b-a).*(zeta(Index)+1)/2+a));
I=(b-a)/2*Iunit;

disp(' '); disp(strcat('The integral is = ',num2str(I)));
% ------------------------end of program ---------------------------