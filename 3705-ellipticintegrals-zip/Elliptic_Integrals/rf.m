%
% rf(x, y, z, errtol)
%
% Inputs:
%
%   x       Input vector size 1xN.
%   y       Input vector size 1xN.
%   z       Input vector size 1xN.
%   errtol  Error tolerance.
%
% Matlab function to compute Carlson's symmetric elliptic integral Rf.
% Implementation of Carlson's Duplication Algorithm 1 in "Computing
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
%                    1.D-3      3.D-19
%                    3.D-3      2.D-16
%                    1.D-2      3.D-13
%                    3.D-2      2.D-10
%                    1.D-1      3.D-7
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

function f = rf(x, y, z, errtol)

% Argument limits as set by Carlson:
LoLim = 5.0 * realmin;
UpLim = 5.0 * realmax;

% Check input arguments for acceptability:
mask = (min([x; y; z]) >= 0) & ...
       (min([(x + y); (x + z); (y + z)]) >= LoLim) & ...
       (max([x; y; z]) < UpLim);

% Define internally acceptable variable ranges for iterations:
Xi = x(mask);
Yi = y(mask);
Zi = z(mask);

% Carlson's duplication algorithm for Rf:
Xn = Xi;
Yn = Yi;
Zn = Zi;
Mu = (Xn + Yn + Zn) / 3.0d+0;
Xndev = 2.0 - (Mu + Xn) ./ Mu;
Yndev = 2.0 - (Mu + Yn) ./ Mu;
Zndev = 2.0 - (Mu + Zn) ./ Mu;
epslon = max( abs([Xndev Yndev Zndev]) );
while (epslon >= errtol)
    Xnroot = sqrt(Xn);
    Ynroot = sqrt(Yn);
    Znroot = sqrt(Zn);
    lambda = Xnroot .* (Ynroot + Znroot) + Ynroot .* Znroot;
    Xn = 0.25 * (Xn + lambda);
    Yn = 0.25 * (Yn + lambda);
    Zn = 0.25 * (Zn + lambda);
    Mu = (Xn + Yn + Zn) / 3.0d+0;
    Xndev = 2.0 - (Mu + Xn) ./ Mu;
    Yndev = 2.0 - (Mu + Yn) ./ Mu;
    Zndev = 2.0 - (Mu + Zn) ./ Mu;
    epslon = max( abs([Xndev Yndev Zndev]) );
end
C1 = 1.0 / 24.0;
C2 = 3.0 / 44.0;
C3 = 1.0 / 14.0;
E2 = Xndev .* Yndev - Zndev .* Zndev;
E3 = Xndev .* Yndev .* Zndev;
S = 1.0 + (C1 * E2 - 0.1D0 - C2 * E3) .* E2 + C3 * E3;
f(mask) = S ./ sqrt(Mu);

% Return NaN's where input argument was out of range:
f(~mask) = NaN;
