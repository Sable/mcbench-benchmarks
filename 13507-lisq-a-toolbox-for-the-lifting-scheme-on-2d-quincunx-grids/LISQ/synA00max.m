function A00 = synA00max(A10, A01, cmin)
%------------------------------------------------------------------------------
%
% For each point of colour 00 this function assigns the maximum value at the
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
  S=max(extL(A01, cmin), extR(A01, cmin));
elseif m00 == m01
  S=max(A01, stripR(extL(A01, cmin)));
else
  disp([' size A10 = ' int2str(size(A10)) ' size A01 = ' int2str(size(A01))]);
  error(' synA00max - A10 and A01 do not match ')
end
if     n00 == n10+1
  T=max(extD(A10, cmin), extU(A10, cmin));
elseif n00 == n10 
  T=max(A10, stripD(extU(A10, cmin)));
else
  disp([' size A10 = ' int2str(size(A10)) ' size A01 = ' int2str(size(A01))]);
  error(' synA00max - A10 and A01 do not match ')
end
%Note: all(size(S) == size(T)) & all(size(S) == [n00 m00])
A00=max(S, T);
%-----------------------------------------------------------------------------
