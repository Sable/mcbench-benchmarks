function val = m00Q0011(F00, F11)
%------------------------------------------------------------------------------
%
% Integrates interpolated gridfunction F on quincunx grid (F00 united with F11)
% where interpolation is assumed piecewise constant.
%
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 1, 2001.
%  2001 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[hx, hy] = Q0011gridfdims(F00, F11);
Qhxy = 2 * hx * hy;
val = ( sum(sum(F00)) + sum(sum(F11)) ) * Qhxy;
%------------------------------------------------------------------------------
