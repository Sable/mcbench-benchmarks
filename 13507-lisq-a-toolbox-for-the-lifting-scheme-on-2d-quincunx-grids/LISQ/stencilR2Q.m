function [StencilQ, CenterQ] = stencilR2Q(Stencil, Center)
%------------------------------------------------------------------------------
%
% This function transforms a stencil on an ordinary rectangular grid into a 
% corresponding stencil on a quincunx grid.
%
% Stencil  = input stencil
%
% Center   = center of Stencil
%
% StencilQ = output stencil at quincunx grid
%
% CenterQ  = center of StencilQ
%
% See also: stencilUPSaVC
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 20, 2000.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
o=[0 0];
if ~all(size(o) == size(Center))
  error(' stencilR2Q - unexpected dimensions of Center ')
else
  clear o;
end
[n, m] = size(Stencil);
CenterQ = [(Center(1)-Center(2)+m) (Center(1)+Center(2)-1)];
nQ = n+m-1;
StencilQ = reshape(linspace(0,0,nQ*nQ),nQ,nQ);
for i=1:n
   for j=1:m
      StencilQ(i-j+m, i+j-1) = Stencil(i, j);
   end
end
%------------------------------------------------------------------------------
