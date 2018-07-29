function G = rayxgridfRVC(F, transla, val)
%------------------------------------------------------------------------------
% Multiplies gridfunction F with element of stencil given by its value
% val and its position transla.
% Excess area is filled by Vertex-Centered (VC) Reflection across boundaries.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: June 23, 2000.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
o=[0 0];
if ~all(size(o) == size(transla))
  error(' rayxgridfRVC - unexpected dimensions of transla ')
end
if val == 0
  G = zeros(size(F));
elseif val == 1
  G = moveLRRVC(moveUDRVC(F, -transla(1)), -transla(2));
else
  G = val * moveLRRVC(moveUDRVC(F, -transla(1)), -transla(2));
end
%------------------------------------------------------------------------------
