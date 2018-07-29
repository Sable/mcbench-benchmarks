function val = m00Q1001(F10, F01)
%------------------------------------------------------------------------------
%
% Integrates interpolated gridfunction F on quincunx grid (F10 united with F01)
% where interpolation is assumed piecewise constant.
%
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 12, 2000.
%  2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[hx, hy] = Q1001gridfdims(F10, F01);
Qhxy = 2 * hx * hy;
val = ( sum(sum(F10)) + sum(sum(F01)) ) * Qhxy;
%------------------------------------------------------------------------------
