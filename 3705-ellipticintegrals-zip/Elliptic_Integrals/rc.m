
%
% rc(x, y, errtol)
%
% Inputs:
%
%   x       Input vector size 1xN.
%   y       Input vector size 1xN.
%   errtol  Error tolerance.
%
% Matlab function to compute Carlson's symmetric elliptic integral Rc.
% Implementation of Carlson's Duplication Algorithm 2 in "Computing
% Elliptic Integrals by Duplication," by B. C. Carlson, Numer. Math.
% 33, 1-16 (1979).
%
% Returns NaN's for any argument values outside input range.
%
% Algorithm is also from Carlson's ACM TOMS Algorithm 577.
%
% This code is a complete rewrite of the algorithm in vectorized form.
% It was not produced by running a FORTRAN to Matlab converter.
%
% The following text is copied from ACM TOMS Algorithm 577 FORTRAN code:
%
%   X AND Y ARE THE VARIABLES IN THE INTEGRAL RC(X,Y).
%
%   ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE.
%   RELATIVE ERROR DUE TO TRUNCATION IS LESS THAN
%   16 * ERRTOL ** 6 / (1 - 2 * ERRTOL).
%
%   SAMPLE CHOICES:  ERRTOL     RELATIVE TRUNCATION
%                               ERROR LESS THAN
%                    1.D-3      2.D-17
%                    3.D-3      2.D-14
%                    1.D-2      2.D-11
%                    3.D-2      2.D-8
%                    1.D-1      2.D-5
%
% Note by TRH:
%
%   Absolute truncation error when the integrals are order 1 quantities
%   is closer to errtol, so be careful if you want high absolute precision.
%
% Thomas R. Hoffend Jr., Ph.D.
% 3M Company
% 3M Center Bldg. 236-GC-26
% St. Paul, MN 55144
% trhoffendjr@mmm.com
%

function f = rc(x, y, errtol)

% Argument limits as set by Carlson:
LoLim = 5.0 * realmin;
UpLim = 5.0 * realmax;

% Check input arguments for acceptability:
mask = ( ((x + y) >= LoLim) & ( max([x; y]) < UpLim ) );

% Define internally acceptable variable ranges for iterations:
Xi = x(mask);
Yi = y(mask);

% Carlson's duplication algorithm:
Xn = Xi;
Yn = Yi;
Mu = (Xn + Yn + Yn) / 3.0d+0;
Sn = (Yn + Mu) ./ Mu - 2.0;
while (abs(Sn) >= errtol)
    lambda = 2.0 * sqrt(Xn) .* sqrt(Yn) + Yn;
    Xn = 0.25 * (Xn + lambda);
    Yn = 0.25 * (Yn + lambda);
    Mu = (Xn + Yn + Yn) / 3.0d+0;
    Sn = (Yn + Mu) ./ Mu - 2.0;
end
C1 = 1.0 / 7.0;
C2 = 9.0 / 22.0;
S = Sn.*Sn .* ( 0.3 + Sn .* (C1 + Sn .* (0.375D0 + Sn * C2)));
f(mask) = (1.0 + Sn) ./ sqrt(Mu);

% Return NaN's where input argument was out of range:
f(~mask) = NaN;


