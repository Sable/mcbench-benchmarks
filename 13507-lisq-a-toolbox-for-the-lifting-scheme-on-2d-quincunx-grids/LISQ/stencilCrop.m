function [StencilC, CenterC] = stencilCrop(Stencil, Center)
%------------------------------------------------------------------------------
%
% This function crops a stencil at its bounds, in case all values are
% zero on the bounds and the center remains within the stencil.
% For dimensions <=3 no (more) cropping is performed.
%
% Stencil  = input stencil
%
% Center   = center of Stencil
%
% StencilC = output stencil (cropped)
%
% CenterC  = center of StencilC
%
% See also: stencilR2Q
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: January 24, 2001.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
o=[0 0];
if ~all(size(o) == size(Center))
  error(' stencilCrop - unexpected dimensions of Center ')
else
  clear o;
end
StencilC = Stencil;
CenterC = Center;
%
[n, m] = size(Stencil);
for j = n:-1:4
   [nC, mC] = size(StencilC);
   v = StencilC(nC,:);
   if any(v) || CenterC(1)>=nC
     break;
   else
     StencilC = StencilC(1:(nC-1),:);
   end
end
for j = m:-1:4
   [nC, mC] = size(StencilC);
   v = StencilC(:,mC)';
   if any(v) || CenterC(2)>=mC
     break;
   else
     StencilC = StencilC(:,1:(mC-1));
   end   
end
%
[n, m] = size(StencilC);
for j = 1:(n-3)
   [nC, mC] = size(StencilC);
   v = StencilC(1,:);
   if any(v) || CenterC(1)<=1
     break;
   else
     StencilC = StencilC(2:nC,:);
     CenterC = [(CenterC(1)-1) CenterC(2)];
   end
end
for j = 1:(m-3)
   [nC, mC] = size(StencilC);
   v = StencilC(:,1)';
   if any(v) || CenterC(2)<=1
     break;
   else
     StencilC = StencilC(:,2:mC);
     CenterC = [CenterC(1) (CenterC(2)-1)];
   end   
end
%

