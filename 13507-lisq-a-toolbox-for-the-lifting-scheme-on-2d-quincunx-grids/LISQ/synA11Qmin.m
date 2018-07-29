function A11 = synA11Qmin(A00, sizeA11, cmax)
%-----------------------------------------------------------------------------
%
% For each point of colour 11 this function assigns the minimum value at the
% neighbouring gridpoints of colour 00.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 12, 2001.
% (c) 1998-2002 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
[n00, m00]=size(A00);
if nargin == 3
  o=[0 0];
  if ~all(size(o) == size(sizeA11))
    error(' synA11Qmin - unexpected dimensions of sizeA11 ')
  else
    clear o;
    n11=sizeA11(1);
    m11=sizeA11(2);    
  end
elseif nargin == 2
  n11=n00-1;
  m11=m00-1;
else
  error(' synA11Qmin - number of arguments should be either 2 or 3 ')
end
%[n11, m11]=size(A11);
if m11 == m00-1
  if n11 == n00-1
    S = min(stripL(A00), stripR(A00));
    A11=min(stripD(S), stripU(S));
  elseif n11 == n00
    S = min(stripL(A00), stripR(A00));
    A11=min(S, stripU(extD(S, cmax)));    
  else
    disp([' size A00 = ' int2str(size(A00)) ' size A11 = ' int2str([n11 m11])]);
    error(' synA11Qmin - A00 and target A11 do not match ');
  end
elseif m11 == m00
  if n11 == n00-1
    S = min(stripL(extR(A00, cmax)), A00);
    A11=min(stripD(S), stripU(S));
  elseif n11 == n00
    S = min(stripL(extR(A00, cmax)), A00);
    A11=min(S, stripU(extD(S, cmax)));    
  else
    disp([' size A00 = ' int2str(size(A00)) ' size A11 = ' int2str([n11 m11])]);
    error(' synA11Qmin - A00 and target A11 do not match ');
  end
else
  disp([' size A00 = ' int2str(size(A00)) ' size A11 = ' int2str([n11 m11])]);
  error(' synA11Qmin - A00 and target A11 do not match ');
end
%------------------------------------------------------------------------------
