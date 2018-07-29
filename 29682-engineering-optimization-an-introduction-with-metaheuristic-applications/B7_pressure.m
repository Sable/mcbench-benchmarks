
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


% Design Optimization of a Pressure Vessel using fmincon             %
% This is essentially a different problem as integer multiples       %
% are not applied.  If leaves an exercise to modify the program that %
% the first two design variables are the integer multiples of 0.0625 %
% ------------------------------------------------------------------ %

function B7_pressure
  
  d=0.0625;
  % Linear inequality constraints
  A=[-1 0 0.0193 0;0 -1 0.00954 0;0 0 0 1];
  b=[0; 0; 240];
  % Simple bounds
  Lb=[d; d; 10; 10];
  Ub=[99*d; 99*d; 200; 200];
  x0=Lb+(Ub-Lb).*rand(size(Lb));
  options=optimset('Display','iter','TolFun',1e-08);
  [x,fval]=fmincon(@objfun,x0,A,b,[],[],Lb,Ub,@nonfun,options)

% The objective function
function f=objfun(x)
f=0.6224*x(1)*x(3)*x(4)+1.7781*x(2)*x(3)^2 ...
  +3.1661*x(1)^2*x(4)+19.84*x(1)^2*x(3)

% Nonlinear constraints
function [g,geq]=nonfun(x)
% Nonlinear inequality
  g=-pi*x(3)^2*x(4)-4*pi/3*x(3)^3+1296000;
% Equality constraint [none]
  geq=[];
