function val = Q0011mupq(F00, F11, p, q, Center)
%------------------------------------------------------------------------------
%
% This function computes the central moments mu_{pq} of the gridfunction F
% (seen as a density distribution) where F is a quincunx gridfunction defined
% by the union (F00 U F11).
%
% Input:
% F00    = Gridfunction that with F11 constitutes a quincunx gridfunction
% F11    = Gridfunction that with F00 constitutes a quincunx gridfunction
% p, q   = order of the central moment (p in x-dir, q in y-dir).
% Center = Center of mass (optional argument)
%
% Note: calls Q0011mupq(F00, F11,1,0) and Q0011mupq(F00, F11,0,1) should
%       result into zero (apart from rounding error).
%
% See also m00, m01, m10, mupq, Q1001mupq
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
    error(' Q0011mupq - unexpected dimensions of Center ')
  else
    clear o;
  end
elseif nargin == 4
  c = Q0011masscenter(F00, F11);
else
  error(' Q0011mupq - number of arguments should be either 4 or 5 ')
end
%
[hx, hy] = Q0011gridfdims(F00, F11);
Qhxy = 2 * hx * hy;
%
[F00xcp, F11xcp] = Q0011xcpowp(F00, F11, p, c(1));
[F00ycp, F11ycp] = Q0011ycpowp(F00, F11, q, c(2));
%
val =  ( sum(sum( F00xcp.*F00ycp.*F00)) + ...
         sum(sum( F11xcp.*F11ycp.*F11)) ) * Qhxy;
%------------------------------------------------------------------------------

