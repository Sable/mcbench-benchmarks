function A00 = synA00Qmax(A11, sizeA00, cmin)
%-----------------------------------------------------------------------------
%
% For each point of colour 00 this function assigns the maximum value at the
% neighbouring gridpoints of colour 11.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 12, 2001.
% (c) 1998-2002 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
[n11, m11]=size(A11);
if nargin == 3
  o=[0 0];
  if ~all(size(o) == size(sizeA00))
    error(' synA00Qmax - unexpected dimensions of sizeA00 ')
  else
    clear o;
    n00=sizeA00(1);
    m00=sizeA00(2);    
  end
elseif nargin == 2
  n00=n11+1;
  m00=m11+1;
else
  error(' synA00Qmax - number of arguments should be either 2 or 3 ')
end
%[n00, m00]=size(A00);
if m00 == m11+1
  if n00 == n11+1
    S = max(extL(A11, cmin), extR(A11, cmin));
    A00=max(extD(S, cmin), extU(S, cmin));
  elseif n00 == n11
    S = max(extL(A11, cmin), extR(A11, cmin));
    A00=max(S, stripD(extU(S, cmin)));    
  else
    disp([' size A11 = ' int2str(size(A11)) ' size A00 = ' int2str([n00 m00])]);
    error(' synA00Qmax - A11 and target A00 do not match ');
  end
elseif m00 == m11
  if n00 == n11+1
    S = max(stripR(extL(A11, cmin)), A11);
    A00=max(extD(S, cmin), extU(S, cmin));
  elseif n00 == n11
    S = max(stripR(extL(A11, cmin)), A11);
    A00=max(S, stripD(extU(S, cmin)));
  else
    disp([' size A11 = ' int2str(size(A11)) ' size A00 = ' int2str([n00 m00])]);
    error(' synA00Qmax - A11 and target A00 do not match ');
  end
else
  disp([' size A11 = ' int2str(size(A11)) ' size A00 = ' int2str([n00 m00])]);
  error(' synA00Qmax - A11 and target A00 do not match ');
end
%------------------------------------------------------------------------------
