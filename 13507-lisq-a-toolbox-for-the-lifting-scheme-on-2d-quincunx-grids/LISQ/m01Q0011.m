function val = m01Q0011(F00, F11)
%------------------------------------------------------------------------------
%
% Integrates interpolated gridfunction {F00 U F11} times y,
% interpolation is assumed piecewise constant.
% The result corresponds to a first order moment.
%
% See also: m01, m01Q1001
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 5, 2002.
%  2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[hx, hy] = Q0011gridfdims(F00, F11);
Qhxy = 2 * hx * hy;
%
[F00ycp, F11ycp] = Q0011ycpowp(F00, F11, 1, 0.0);
val = sum(sum( F00ycp.*F00 ));
clear F00ycp;
%
val = (val + sum(sum( F11ycp.*F11 ))) * Qhxy; 
clear F11ycp;        
%------------------------------------------------------------------------------
