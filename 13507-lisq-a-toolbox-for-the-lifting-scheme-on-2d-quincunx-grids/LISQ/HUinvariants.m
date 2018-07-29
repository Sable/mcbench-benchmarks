function [sims, orthos, simorthos] = HUinvariants(mass, mus)
%------------------------------------------------------------------------------
%
% Computation of similitude invariants, orthogonal invariants
% and similitude & orthogonal invariants combined, all upto 3rd order.
%
% Input:
% mass = mass of gridfunction
% mus  = vector of length 7, containing the 2nd & 3rd order moments 
%        mu20 mu11 mu02 mu30 mu21 mu12 mu03
%
% Output:
% sims      = Central moments made invariant to similitude transforms
% orthos    = Central moments made orthogonally invariant
% simorthos = Invariants w.r.t. both similitude and orthogonal transformations
%
% See pages 180, 181, 185 in:
% Ming-Kuei Hu  Visual Pattern Recognition by Moment Invariants,
% IRE Transactions on Information Theory, pp. 179--187 (1962).
%
% In order to get the invariants into the same range, necessary scaling
% is performed.
%
% See also: momentsupto3, Q1001momentsupto3, Q0011momentsupto3
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 8, 2001.
%  2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
%
if length(mus) ~= 7
  error(' HUinvariants - length vector of mus should be 7 ')
end
if mass == 0
  error(' HUinvariants - mass vanishes in denominator ')
elseif mass < 0
  disp(' HUinvariants -warning - mass is negative ')
end
%
mu20 = mus(1);
mu11 = mus(2);
mu02 = mus(3);
mu30 = mus(4);
mu21 = mus(5);
mu12 = mus(6); 
mu03 = mus(7);
% [mu20 mu11 mu02 mu30 mu21 mu12 mu03] = mus;
%
% Central moments made invariant to similitude transforms
ma2  = mass^2;
ma5o2= mass^(5/2);
sims = [mu20/ma2   mu11/ma2   mu02/ma2 ...
        mu30/ma5o2 mu21/ma5o2 mu12/ma5o2 mu03/ma5o2];
%
% Central moments made orthogonally invariant
v1 = mu20 + mu02;
v2 = (mu20 - mu02)^2 + 4 * mu11^2;
v3 = (mu30 - 3 * mu12)^2 + (3 * mu21 - mu03)^2;
v4 = (mu30 + mu12)^2 + (mu21 + mu03)^2;
v5 = (mu30 - 3 * mu12) * (mu30 + mu12) * ... 
       ((mu30 + mu12)^2 - 3 * (mu21 + mu03)^2) + ...
       (3 * mu21 - mu03) * (mu21 + mu03) * (3*(mu30+mu12)^2 - (mu21 + mu03)^2);
v6 = (mu20 - mu02) * ((mu30 + mu12)^2 - (mu21 + mu03)^2) + ...
       4 * mu11 * (mu30 + mu12) * (mu21 + mu03);
v7 = (3 * mu21 - mu03) * (mu30 + mu12) * ...
       ((mu30 + mu12)^2 - 3 * (mu21 + mu03)^2) - (mu30 - 3 * mu12) * ...
       (mu21 + mu03) * (3 * (mu30 + mu12)^2 - (mu21 + mu03)^2);
%
% In order to get v1, . . . , v7 in the same range,
% we apply a homogeneity condition.
w1 = v1;
w2 = sign(v2) * (abs(v2))^(1/2);
w3 = sign(v3) * (abs(v3))^(1/2);
w4 = sign(v4) * (abs(v4))^(1/2);
w5 = sign(v5) * (abs(v5))^(1/4);
w6 = sign(v6) * (abs(v6))^(1/3);
w7 = sign(v7) * (abs(v7))^(1/4);
orthos = [w1 w2 w3 w4 w5 w6 w7];
%
% Assuming that mass should be orthogonal invariant, we come up with the
% following invariants w.r.t. both similitude and orthogonal transformations:
%
z1 = v1/ma2;
z2 = v2/(ma2^2);
z3 = v3/(ma5o2)^2;
z4 = v4/(ma5o2)^2;
z5 = v5/(ma5o2)^4;
z6 = v6/(ma2*ma5o2^2);
z7 = v7/(ma5o2^4);
%
% In order to get z1, . . . , z7 in the same range,
% we apply a homogeneity condition.
%z1  = z1;
z2  = sign(z2) * (abs(z2))^(1/2);
z3  = sign(z3) * (abs(z3))^(1/3);
z4  = sign(z4) * (abs(z4))^(1/3);
z5  = sign(z5) * (abs(z5))^(1/6);
z6  = sign(z6) * (abs(z6))^(1/4);
z7  = sign(z7) * (abs(z7))^(1/6);
simorthos = [z1 z2 z3 z4 z5 z6 z7];
%------------------------------------------------------------------------------
