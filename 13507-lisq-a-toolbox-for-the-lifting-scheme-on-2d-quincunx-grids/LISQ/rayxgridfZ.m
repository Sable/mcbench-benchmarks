function G = rayxgridfZ(F, transla, val)
%------------------------------------------------------------------------------
% Multiplies gridfunction F with element of stencil given by its value
% val and its position transla.
% Excess area is filled by padding with zeroes.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: June 23, 2000.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
o=[0 0];
if ~all(size(o) == size(transla))
  error(' rayxgridfZ - unexpected dimensions of transla ')
end
G = val * moveLRZ(moveUDZ(F, -transla(1)), -transla(2));
%------------------------------------------------------------------------------
