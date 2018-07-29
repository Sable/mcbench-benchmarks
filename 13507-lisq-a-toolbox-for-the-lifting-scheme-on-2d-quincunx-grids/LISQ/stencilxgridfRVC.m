function F = stencilxgridfRVC(G, Stencil, center)
%------------------------------------------------------------------------------
% Multiplies gridfunction G with Stencil.
% Excess area is filled by Vertex-Centered (VC) Reflection across boundaries.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: June 26, 2000.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
o=[0 0];
if ~all(size(o) == size(center))
  error(' stencilxgridfRVC - unexpected dimensions of center ')
end
F=zeros(size(G));
[n, m] = size(Stencil);
for i=1:n
   for j=1:m
      sij = Stencil(i,j);
      if sij ~= 0   
        F = F + rayxgridfRVC(G, ([i j] - center), sij);
      end
   end
end   
%------------------------------------------------------------------------------
