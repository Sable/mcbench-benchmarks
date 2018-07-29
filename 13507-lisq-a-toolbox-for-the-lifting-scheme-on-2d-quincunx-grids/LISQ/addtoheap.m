function H = addtoheap(F, H)
%------------------------------------------------------------------------------
%
% Appends 2D gridfunction to 1D storage (heap) H.
%
% Note: because of reasons of efficiency we opt for columnwise storage as
%       in Matlab. This is also how Fortran stores matrices.
%
% See also: storeR, storeQ.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: May 5, 2002.
%  2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[nH, mH] = size(H);
if ~isempty(H)
  if mH ~= 1
    error(' addtoheap - heap should be column vector ')
  end
end
% [nF, mF] = size(F);
% H = [H reshape(F, 1, nF*mF)]; i.e. storage as rowvector until dd020505
% H = [H reshape(F, nF*mF, 1)]; i.e. storage as columnvector, but the following
%                               is straightforward and equivalent:
H = [H; F(:)];
%------------------------------------------------------------------------------
