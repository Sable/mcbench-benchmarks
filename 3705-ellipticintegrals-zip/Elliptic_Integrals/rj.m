%
% rj(x, y, z, p, errtol)
%
% Inputs:
%
%   x       Input vector size 1xN.
%   y       Input vector size 1xN.
%   z       Input vector size 1xN.
%   p       Input vector size 1xN.
%   errtol  Error tolerance.
%
% Matlab function to compute Carlson's symmetric elliptic integral Rj.
% Implementation of Carlson's Duplication Algorithm 3 in "Computing
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
%                    1.D-3      4.D-18
%                    3.D-3      3.D-15
%                    1.D-2      4.D-12
%                    3.D-2      3.D-9
%                    1.D-1      4.D-6
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

function f = rj(x, y, z, p, errtol)

% Argument limits as set by Carlson:
LoLim = 5.0 * realmin;
UpLim = 5.0 * realmax;

% Check input arguments for acceptability:
mask = (min([x; y; z]) >= 0) & ...
       (min([(x + y); (x + z); (y + z); p]) >= LoLim) & ...
       (max([x; y; z; p]) < UpLim);

% Define internally acceptable variable ranges for iterations:
Xi = x(mask);
Yi = y(mask);
Zi = z(mask);
Pi = p(mask);

% Carlson's duplication algorithm for Rj:
Xn = Xi;
Yn = Yi;
Zn = Zi;
Pn = Pi;
sigma = 0.0;
power4 = 1.0;
etolrc = 0.5 * errtol;
Mu = (Xn + Yn + Zn + Pn + Pn) * 0.2;
Xndev = (Mu - Xn) ./ Mu;
Yndev = (Mu - Yn) ./ Mu;
Zndev = (Mu - Zn) ./ Mu;
Pndev = (Mu - Pn) ./ Mu;
epslon = max( abs([Xndev Yndev Zndev Pndev]) );
while (epslon >= errtol)
    Xnroot = sqrt(Xn);
    Ynroot = sqrt(Yn);
    Znroot = sqrt(Zn);
    lambda = Xnroot .* (Ynroot + Znroot) + Ynroot .* Znroot;
    alpha = Pn .* (Xnroot + Ynroot + Znroot) + Xnroot .* Ynroot .* Znroot;
    alpha = alpha .* alpha;
    beta = Pn .* (Pn + lambda) .* (Pn + lambda);
    sigma = sigma + power4 .* rc(alpha, beta, etolrc);
    % Here we might need to shrink the size of the arrays if alpha, beta
    % out of range for Rc.
    mask = ~isnan(sigma);
    power4 = 0.25 * power4;
    Xn = 0.25 * (Xn(mask) + lambda(mask));
    Yn = 0.25 * (Yn(mask) + lambda(mask));
    Zn = 0.25 * (Zn(mask) + lambda(mask));
    Pn = 0.25 * (Pn(mask) + lambda(mask));
    Mu = (Xn + Yn + Zn + Pn + Pn) * 0.2;
    Xndev = (Mu - Xn) ./ Mu;
    Yndev = (Mu - Yn) ./ Mu;
    Zndev = (Mu - Zn) ./ Mu;
    Pndev = (Mu - Pn) ./ Mu;
    epslon = max( abs([Xndev Yndev Zndev Pndev]) );
end
C1 = 3.0 / 14.0;
C2 = 1.0 / 3.0;
C3 = 3.0 / 22.0;
C4 = 3.0 / 26.0;
EA = Xndev .* Yndev - Zndev .* Zndev;
EB = Xndev .* Yndev .* Zndev;
EC = Pndev .* Pndev;
E2 = EA - 3.0 * EC;
E3 = EB + 2.0 * Pndev .* (EA - EC);
S1 = 1.0 + E2 .* (-C1 + 0.75D0 * C3 * E2 - 1.5D0 * C4 * E3);
S2 = EB .* (0.5D0 * C2 + Pndev .* (-C3 -C3 + Pndev*C4));
S3 = Pndev .* EA .* (C2 - Pndev*C3) - C2*Pndev .* EC;
f(mask) = 3.0 * sigma + power4 * (S1 + S2 + S3) ./ (Mu .* sqrt(Mu));

% Return NaN's where input argument was out of range:
f(~mask) = NaN;
