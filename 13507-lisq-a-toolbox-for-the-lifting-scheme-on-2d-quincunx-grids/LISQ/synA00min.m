function A00 = synA00min(A10, A01, cmax)
%-----------------------------------------------------------------------------
%
% For each point of colour 00 this function assigns the minimum value at the
% neighbouring gridpoints of colours 10 and 01.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 7, 2001.
% (c) 1998-2002 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
[n10, m10]=size(A10);
[n01, m01]=size(A01);
n00=n01;
m00=m10;
%[n00, m00]=size(A00);
if     m00 == m01+1
  S=min(extL(A01, cmax), extR(A01, cmax));
elseif m00 == m01
  S=min(A01, stripR(extL(A01, cmax)));
else
  disp([' size A10 = ' int2str(size(A10)) ' size A01 = ' int2str(size(A01))]);
  error(' synA00min - A10 and A01 do not match ')
end
if     n00 == n10+1
  T=min(extD(A10, cmax), extU(A10, cmax));
elseif n00 == n10 
  T=min(A10, stripD(extU(A10, cmax)));
else
  disp([' size A10 = ' int2str(size(A10)) ' size A01 = ' int2str(size(A01))]);
  error(' synA00min - A10 and A01 do not match ')
end
%Note: all(size(S) == size(T)) & all(size(S) == [n00 m00])
A00=min(S, T);
%-----------------------------------------------------------------------------
