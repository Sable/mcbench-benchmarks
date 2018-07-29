function A01 = synA01min(A11, A00, cmax)
%-----------------------------------------------------------------------------
%
% For each point of colour 01 this function assigns the minimum value at the
% neighbouring gridpoints of colours 11 and 00.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 7, 2001.
% (c) 1998-2002 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
[n00, m00]=size(A00);
[n11, m11]=size(A11);
%[n01, m01]=size(A01);
n01=n00;
m01=m11;
if     m01 == m00
  S=min(stripL(extR(A00,cmax)), A00);
elseif m01 == m00-1 
  S=min(stripL(A00), stripR(A00));
else
  disp([' size A11 = ' int2str(size(A11)) ' size A00 = ' int2str(size(A00))]);
  error(' synA01min - A11 and A00 do not match ');
end
if     n01 == n11
  T=min(A11, stripD(extU(A11, cmax)));
elseif n01 == n11+1 
  T=min(extD(A11, cmax), extU(A11, cmax));
else
  disp([' size A11 = ' int2str(size(A11)) ' size A00 = ' int2str(size(A00))]);
  error(' synA01min - A11 and A00 do not match ');
end
%Note: all(size(S) == size(T)) & all(size(S) == [n01 m01]) always holds.
A01=min(S, T);
%-----------------------------------------------------------------------------

