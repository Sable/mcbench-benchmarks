function val = mupq(F, p, q, Center)
%------------------------------------------------------------------------------
%
% This function computes the central moments mu_{pq} of the gridfunction F
% (seen as a density distribution).
%
% F      = input gridfunction (discrete density distribution).
%
% p, q   = input, order of the central moment (p in x-dir, q in y-dir).
%
% Center = input (optional argument), center of mass
%
% Note: calls mupq(F,1,0) and mupq(F,0,1) should result into zero (apart from
%       rounding error).
%
% See also m00, m01, m10
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 27, 2000.
%  2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
if nargin == 4
  c = Center;
  o=[0 0];
  if ~all(size(o) == size(Center))
    error(' mupq - unexpected dimensions of Center ')
  else
    clear o;
  end
elseif nargin == 3
  c = masscenter(F);
else
  error(' mupq - number of arguments should be either 3 or 4 ')
end
[hx, hy] = gridfdims(F);
val = sum(sum(  xcpowp(F, p, c(1)) ...
              .*ycpowp(F, q, c(2)).*F ))*(hx*hy);
%------------------------------------------------------------------------------
