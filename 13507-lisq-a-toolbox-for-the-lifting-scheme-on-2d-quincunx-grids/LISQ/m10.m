function val = m10(F)
%------------------------------------------------------------------------------
%
% Integrates interpolated gridfunction F times x,
% interpolation is assumed piecewise constant.
% The result corresponds to a first order moment.
%
% See also: m00, m01, mupq
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 27, 2000.
%  2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[hx, hy] = gridfdims(F);
val=sum(sum( xcpowp(F, 1, 0.0).*F ))*(hx*hy);
%------------------------------------------------------------------------------
