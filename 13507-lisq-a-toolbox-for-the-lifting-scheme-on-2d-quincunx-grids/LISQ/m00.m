function val = m00(F)
%------------------------------------------------------------------------------
%
% Integrates interpolated gridfunction F,
% interpolation is assumed piecewise constant.
%
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 23, 2000.
%  2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[hx, hy] = gridfdims(F);
val=sum(sum(F))*(hx*hy);
%------------------------------------------------------------------------------
