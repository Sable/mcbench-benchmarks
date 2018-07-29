function val = m10Q0011(F00, F11)
%------------------------------------------------------------------------------
%
% Integrates interpolated gridfunction {F00 U F11} times x,
% interpolation is assumed piecewise constant.
% The result corresponds to a first order moment.
%
% See also: m10, m10Q1001
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 5, 2002.
%  2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[hx, hy] = Q0011gridfdims(F00, F11);
Qhxy = 2 * hx * hy;
%
[F00xcp, F11xcp] = Q0011xcpowp(F00, F11, 1, 0.0);
val = sum(sum( F00xcp.*F00 ));
clear F00xcp;
%
val = (val + sum(sum( F11xcp.*F11 ))) * Qhxy; 
clear F11xcp;        
%------------------------------------------------------------------------------
