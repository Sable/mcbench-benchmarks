function val = m01(F)
%------------------------------------------------------------------------------
%
% Integrates interpolated gridfunction F times y,
% interpolation is assumed piecewise constant.
% The result corresponds to a first order moment.
%
% See also: m00, m10, mupq
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 27, 2000.
%  2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[hx, hy] = gridfdims(F);
val=sum(sum( ycpowp(F, 1, 0.0).*F ))*(hx*hy);
%------------------------------------------------------------------------------
