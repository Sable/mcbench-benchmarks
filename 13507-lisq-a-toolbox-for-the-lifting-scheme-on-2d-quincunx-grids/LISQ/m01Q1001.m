function val = m01Q1001(F10, F01)
%------------------------------------------------------------------------------
%
% Integrates interpolated gridfunction {F10 U F01} times y,
% interpolation is assumed piecewise constant.
% The result corresponds to a first order moment.
%
% See also: m01
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 12, 2000.
%  2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[hx, hy] = Q1001gridfdims(F10, F01);
Qhxy = 2 * hx * hy;
%
[F10ycp, F01ycp] = Q1001ycpowp(F10, F01, 1, 0.0);
val = sum(sum( F10ycp.*F10 ));
clear F10ycp;
%
val = (val + sum(sum( F01ycp.*F01 ))) * Qhxy; 
clear F01ycp;        
%------------------------------------------------------------------------------
