function [c, mass] = Q0011masscenter(F00, F11)
%------------------------------------------------------------------------------
%
% This function computes the center of mass of gridfunction {F00 U F11}
% (seen as a density distribution).
%
% Beware if {F00 U F11} assumes not mere positive values, does it make sense?
%
% See also: m00Q0011, m10Q0011, m01Q0011, Q1001masscenter
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 5, 2002.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
denomina = m00Q0011(F00, F11);
if denomina == 0
  error(' Q0011masscenter - demoninator vanishes ')
else
  cx = m10Q0011(F00, F11)/denomina;
  cy = m01Q0011(F00, F11)/denomina;  
end
% whether cx, cy < 0 etc. could be checked here (see above warning).
if nargout == 1
  c = [cx cy];
elseif nargout == 2
  c = [cx cy];
  mass = denomina;
else
  error(' Q0011masscenter - wrong number of output arguments ')
end
%------------------------------------------------------------------------------
