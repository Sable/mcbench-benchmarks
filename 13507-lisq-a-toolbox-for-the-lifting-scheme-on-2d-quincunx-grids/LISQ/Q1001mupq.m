function val = Q1001mupq(F10, F01, p, q, Center)
%------------------------------------------------------------------------------
%
% This function computes the central moments mu_{pq} of the gridfunction F
% (seen as a density distribution) where F is a quincunx gridfunction defined
% by the union (F10 U F01).
%
% Input:
% F10    = Gridfunction that with F01 constitutes a quincunx gridfunction
% F01    = Gridfunction that with F10 constitutes a quincunx gridfunction
% p, q   = order of the central moment (p in x-dir, q in y-dir).
% Center = Center of mass (optional argument)
%
% Note: calls Q1001mupq(F10, F01,1,0) and Q1001mupq(F10, F01,0,1) should
%       result into zero (apart from rounding error).
%
% See also m00, m01, m10, mupq, Q0011mupq
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 5, 2002.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
if nargin == 5
  c = Center;
  o=[0 0];
  if ~all(size(o) == size(Center))
    error(' Q1001mupq - unexpected dimensions of Center ')
  else
    clear o;
  end
elseif nargin == 4
  c = Q1001masscenter(F10, F01);
else
  error(' Q1001mupq - number of arguments should be either 4 or 5 ')
end
%
[hx, hy] = Q1001gridfdims(F10, F01);
Qhxy = 2 * hx * hy;
%
[F10xcp, F01xcp] = Q1001xcpowp(F10, F01, p, c(1));
[F10ycp, F01ycp] = Q1001ycpowp(F10, F01, q, c(2));
%
val =  ( sum(sum( F10xcp.*F10ycp.*F10)) + ...
         sum(sum( F01xcp.*F01ycp.*F01)) ) * Qhxy;
%------------------------------------------------------------------------------
