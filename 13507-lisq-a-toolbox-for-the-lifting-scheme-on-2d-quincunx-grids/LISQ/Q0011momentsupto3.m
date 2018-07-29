function [mass, mus, sims, orthos, simorthos] = Q0011momentsupto3(F00, F11)
%------------------------------------------------------------------------------
%
% Computation of central moments (upto 3rd order) is called for, followed by 
% call for similitude invariants, orthogonal invariants and similitude with 
% orthogonal invariants combined.
%
% Input:
% F00       = Gridfunction that with F11 constitutes a quincunx gridfunction
% F11       = Gridfunction that with F00 constitutes a quincunx gridfunction
%
% Output:
% mass      = mass of quincunx gridfunction (F00 U F11)
% mus       = vector of length 7, containing the 2nd & 3rd order moments 
%             mu20 mu11 mu02 mu30 mu21 mu12 mu03
% sims      = Central moments made invariant to similitude transforms
% orthos    = Central moments made orthogonally invariant
% simorthos = Invariants w.r.t. both similitude and orthogonal transformations
%
% See pages 180, 181, 185 in:
% Ming-Kuei Hu  Visual Pattern Recognition by Moment Invariants,
% IRE Transactions on Information Theory, pp. 179--187 (1962).
%
% See also: masscenter, mupq, HUinvariants, momentsupto3, Q1001momentsupto3
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 5, 2001.
% (c) 1999-2001 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
% Mass and center
[c, mass] = Q0011masscenter(F00, F11);
%
% Central moments
mu20 = Q0011mupq(F00, F11, 2, 0, c);
mu11 = Q0011mupq(F00, F11, 1, 1, c);
mu02 = Q0011mupq(F00, F11, 0, 2, c);
%
mu30 = Q0011mupq(F00, F11, 3, 0, c);
mu21 = Q0011mupq(F00, F11, 2, 1, c);
mu12 = Q0011mupq(F00, F11, 1, 2, c);
mu03 = Q0011mupq(F00, F11, 0, 3, c);
%
mus = [mu20 mu11 mu02 mu30 mu21 mu12 mu03];
%
% Invariants
[sims, orthos, simorthos] = HUinvariants(mass, mus);
%
%------------------------------------------------------------------------------
