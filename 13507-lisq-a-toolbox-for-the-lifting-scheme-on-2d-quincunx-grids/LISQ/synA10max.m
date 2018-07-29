function A10 = synA10max(A11, A00, cmin)
%-----------------------------------------------------------------------------
%
% For each point of colour 10 this function assigns the maximum value at the
% neighbouring gridpoints of colours 11 and 00.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 7, 2001.
% (c) 1998-2002 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
[n00, m00]=size(A00);
[n11, m11]=size(A11);
n10=n11;
m10=m00;
%[n10, m10]=size(A10);
if     m10 == m11
  S=max(A11, stripR(extL(A11, cmin)));
elseif m10 == m11+1 
  S=max(extL(A11, cmin), extR(A11, cmin));
else
  disp([' size A11 = ' int2str(size(A11)) ' size A00 = ' int2str(size(A00))]);
  error(' synA10max - A11 and A00 do not match ');
end
if     n10 == n00
  T=max(A00, stripU(extD(A00, cmin)));
elseif n10 == n00-1 
  T=max(stripD(A00), stripU(A00));
else
  disp([' size A11 = ' int2str(size(A11)) ' size A00 = ' int2str(size(A00))]);
  error(' synA10max - A11 and A00 do not match ');
end
%Note: all(size(S) == size(T)) & all(size(S) == [n10 m10]) always holds.
A10=max(S, T);
%-----------------------------------------------------------------------------
