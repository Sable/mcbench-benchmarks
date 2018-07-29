% [z,y]=hypergeometric2F1ODE(a,b,c,zSpan,relTol,absTolF,absTolFp)
%
% Computes the Gauss hypergeometric function 2F1(a,b;c;z) for real z, z<1
% by integrating the defining differential equation using the Matlab differential equation
% solver ode15i. The initial values are set at z=0.
%
%
% a,b,c: scalar - parameters of the Gauss hypergeometric function
% zSpan: vector - The function values are computed within the span given by zSpan.
%  The first element must be zero as the initial values of ode15i are given
%  at zero. The second element must be <1. 2F1 is then evaluated for
%  coordinates chosen the by the differential equation solver within this
%  span. 
%  If zSpan contains more than two elements, then the function is evaluated
%  exactly at these points. The elements must either all be increasing or
%  decreasing.
% relTol, absTolF, absTolFp: scalar - optional parameters determining the tolerance
%  for ode15i (see Matlab help). The accuracy of the resulting
%  hypergeometric function values can be inferior particulary for values
%  that are far away from z=0. At z=1, 2F1 diverges. For points close to zero a tolerance
%  less strict than the default can already yield good results.
%  
%
% z: function output coordinates
% y: values of 2F1 and its derivative at z, the first column contains the
% function values, the second column the derivative
%
% Example: 
% [z y]=hypergeometric2F1ODE(10,11.13,11,[0 -1000]);
% z(end)
% ans =
%        -1000
% y(end,1)
% ans =
%   6.8820e-031
%
% This program follows the idea presented in "Numerical recipes in C, Second Edition",
% 1992, reprinted in 2002, Section 5.14, but is implemented for real
% variables only. 
% 
%
% Sample values at precision: relTol=1e-12, absTolF=1e-40, absTolFp=1e-40;
% Parameters a,b,c      z            hypergeometric2F1ODE    Mathematica precision 12
% 10, 11.13, 11         -1000        6.882032e-031           6.88203163442e-31
%   -------             0.99999999   1.082407e+081           1.08240679687e+81
% 10, 30.98, 11         0.99999999   2.307641e+239           2.30764098825e+239
%   -------             -1000        3.357558e-038           3.35489870441e-38    !!!
%   -------             -100         3.354899e-028           3.35489870441e-28 
%  1, 21.54, 2          -1000        4.868549e-005           0.000486854917235
%   -------             0.99999999   1.017184e+163           1.01718389611e+163
% 5.9561, 0.7, 6.2561   0.9995       55.9807                 55.9807392028
%
% .......................................................................
% 2nd order differential equation for the 
% Gauss hypergeometric function 2F1(a,b;c;z), [Gradshteyn, 1965, 9.151]
%
% z*(1-z)*d^2F/dz^2=a*b*F-[c-(a+b+1)*z]*dF/dz
%
% Transformation to a first order system of differential equations
% with F1=F, F2=dF/dz:
% dF1/dz = F2
% dF2/dz = 1/(z*(1-z))*[a*b-F1-[c-(a+b+1)*z]F2]
% =>
% 0 = dF1/dz - F2
% 0 = z*(1-z)*dF2/dz - [a*b-F1-[c-(a+b+1)*z]F2]
%
% Initial values at z=0
% with F(a,b;c;0)=1, dF(a,b;c;z)/dz|(z=0)=a*b/c,
% d^2F(a,b;c;z)/dz^2|(z=0)=a*b/c*(a+1)*(b+1)/(c+1):
%
% F(0)=[F1(0); F2(0)]=[1; a*b/c];
% dF/dz(0)=[dF1/dz(0); dF2/dz(0)]= [a*b/c; a*b/c*(a+1)*(b+1)/(c+1)];
%
%
% FileName          hypergeometric2F1ODE.m
% Author            Robert Kohlleppel
%
% DATE          VERSION         CHANGES
% 20/07/2007    0.0             initial version

function [z, y]=hypergeometric2F1ODE(a,b,c,zSpan,relTol,absTolF,absTolFp)

if nargin==4
    relTol=1e-12;
    absTolF=1e-40;
    absTolFp=1e-40;
elseif nargin~=7
    error('Wrong number of arguments.');
end;

%% set initial values
F0=[1; a*b/c];
Fp0=[a*b/c; a*b/c*(a+1)*(b+1)/(c+1)];


%% set tolerance values and pass jacobian
options = odeset('RelTol',relTol,'AbsTol',[absTolF absTolFp], ...
                 'Jacobian',@(zPass,FPass,FpPass)FJAC(zPass,FPass,FpPass,a,b,c));

%%  solve the differential equation
[z, y] = ode15i(@(zPass,FPass,FpPass)f(zPass,FPass,FpPass,a,b,c),zSpan,F0,Fp0,options);


end

%% nested functions
% Jacobian
function [dfdF,dfdFp] = FJAC(z,F,Fp,a,b,c)
dfdF= [0       -1; 
       -a*b      c-(a+b+1)*z];
dfdFp=[1 0;
       0 z*(1-z)];
end

% Differential equation
function res = f(z,F,Fp,a,b,c)

res = [Fp(1) - F(2);
        z*(1-z)*Fp(2) - (a*b*F(1)-(c-(a+b+1)*z)*F(2)) ];
end
