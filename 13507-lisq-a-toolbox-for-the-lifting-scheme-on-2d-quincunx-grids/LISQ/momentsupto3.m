function [mass, mus, orthos, sims, simorthos] = momentsupto3(F)
%------------------------------------------------------------------------------
%
% Computation of central moments (upto 3rd order) is called for, followed by 
% call for similitude invariants, orthogonal invariants and similitude with 
% orthogonal invariants combined.
%
% Input:
% F         = Gridfunction defined on a rectangular grid
%
% Output:
% mass      = mass of gridfunction
% mus       = vector of length 7, containing the 2nd & 3rd order moments 
%             mu20 mu11 mu02 mu30 mu21 mu12 mu03
% orthos    = Central moments made orthogonally invariant
% sims      = Central moments made invariant to similitude transforms
% simorthos = Invariants w.r.t. both similitude and orthogonal transformations
%
% References:
% Ming-Kuei Hu  Visual Pattern Recognition by Moment Invariants,
% IRE Transactions on Information Theory, pp. 179--187 (1962)
%  and
% P.M. de Zeeuw,
% A Toolbox for the Lifting Scheme on Quincunx Grids (LISQ),
% CWI Report PNA-R0224,
% Centrum voor Wiskunde en Informatica,
% Amsterdam, 2002.
% http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf
%  and
% P.J. Oonincx, P.M. de Zeeuw,
% Adaptive lifting for shape-based image retrieval,
% Pattern Recognition 36 (2003) 2663--2672.
%
% See also: masscenter, mupq, HUinvariants, Q1001momentsupto3
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 25, 2006.
%  2002--2006 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
% Mass and center
[c, mass] = masscenter(F);
%
% Central moments
mu20 = mupq(F, 2, 0, c);
mu11 = mupq(F, 1, 1, c);
mu02 = mupq(F, 0, 2, c);
%
mu30 = mupq(F, 3, 0, c);
mu21 = mupq(F, 2, 1, c);
mu12 = mupq(F, 1, 2, c);
mu03 = mupq(F, 0, 3, c);
%
mus = [mu20 mu11 mu02 mu30 mu21 mu12 mu03];
%
% Invariants
[sims,orthos,simorthos]= HUinvariants(mass, mus);
%
%------------------------------------------------------------------------------
