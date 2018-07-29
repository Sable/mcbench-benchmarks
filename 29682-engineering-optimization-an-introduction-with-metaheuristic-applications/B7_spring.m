% -----------------------------------------------------------------  %
% Matlab Programs included the Appendix B in the book:               %
%  Xin-She Yang, Engineering Optimization: An Introduction           %
%                with Metaheuristic Applications                     %
%  Published by John Wiley & Sons, USA, July 2010                    %
%  ISBN: 978-0-470-58246-6,   Hardcover, 347 pages                   %
% -----------------------------------------------------------------  %
% Citation detail:                                                   %
% X.-S. Yang, Engineering Optimization: An Introduction with         %
% Metaheuristic Application, Wiley, USA, (2010).                     %
%                                                                    % 
% http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html % 
% http://eu.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html  %
% -----------------------------------------------------------------  %
% ===== ftp://  ===== ftp://   ===== ftp:// =======================  %
% Matlab files ftp site at Wiley                                     %
% ftp://ftp.wiley.com/public/sci_tech_med/engineering_optimization   %
% ----------------------------------------------------------------   %

% Spring Design Optimization using Matlab fmincon                    %
% it requires that Matlab optimization toolbox                       % 
% Alternatively, you can use the constrained FA to do simulations    %
% plase refer to the file: fa_constrained_demo.m                     %

function spring
  format long;
  x0=[0.1; 0.5; 10];
  Lb=[0.05; 0.25; 2.0];  Ub=[2.0; 1.3; 15.0];
  % call matlab optimization toolbox
  [x,fval]=fmincon(@objfun,x0,[],[],[],[],Lb,Ub,@nonfun)

% Objective function
function f=objfun(x)
f=(2+x(3))*x(1)^2*x(2);

% Nonlinear constraints
function [g,geq]=nonfun(x)
% Inequality constraints
  g(1)=1-x(2)^3*x(3)/(71785*x(1)^4);  
  % Notice the typo 7178 (instead of 71785)
  gtmp=(4*x(2)^2-x(1)*x(2))/(12566*(x(2)*x(1)^3-x(1)^4));
  g(2)=gtmp+1/(5108*x(1)^2)-1;
  g(3)=1-140.45*x(1)/(x(2)^2*x(3));
  g(4)=x(1)+x(2)-1.5;
% Equality constraints [none]
geq=[];