function P = putcolor01(A01, sizeP)
%------------------------------------------------------------------------------
%
% Gridfunction A01 is upsampled.
%
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: June 6, 1999.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n, m] = size(A01);
if nargin == 2
  nP = sizeP(1);
  mP = sizeP(2);
  if nP < 2*n-1
    error(' putcolor01 - 1st dimension of P too small ')
  end
  if mP < 2*m
    error(' putcolor01 - 2nd dimension of P too small ')
  end
elseif nargin == 1
  nP = 2*n-1;
  mP = 2*m+1;
else
  error(' putcolor01 - wrong number of arguments ')
end
P=reshape(linspace(0,0,nP*mP),nP,mP);
P(1:2:nP, 2:2:mP)=A01;
%------------------------------------------------------------------------------
