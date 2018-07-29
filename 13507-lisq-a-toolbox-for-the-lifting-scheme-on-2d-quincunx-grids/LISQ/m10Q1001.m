function val = m10Q1001(F10, F01)
%------------------------------------------------------------------------------
%
% Integrates interpolated gridfunction {F10 U F01} times x,
% interpolation is assumed piecewise constant.
% The result corresponds to a first order moment.
%
% See also: m10
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 12, 2000.
%  2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[hx, hy] = Q1001gridfdims(F10, F01);
Qhxy = 2 * hx * hy;
%
[F10xcp, F01xcp] = Q1001xcpowp(F10, F01, 1, 0.0);
val = sum(sum( F10xcp.*F10 ));
clear F10xcp;
%
val = (val + sum(sum( F01xcp.*F01 ))) * Qhxy; 
clear F01xcp;        
%------------------------------------------------------------------------------
