function A11 = synA11min(A10, A01, cmax)
%-----------------------------------------------------------------------------
%
% For each point of colour 11 this function assigns the minimum value at the
% neighbouring gridpoints of colours 10 and 01.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 7, 2001.
% (c) 1998-2002 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
[n10, m10]=size(A10);
[n01, m01]=size(A01);
n11=n10;
m11=m01;
%[n11, m11]=size(A11);
if     m11 == m10
  S=min(stripL(extR(A10, cmax)), A10);
elseif m11 == m10-1 
  S=min(stripL(A10), stripR(A10));
else
  disp([' size A10 = ' int2str(size(A10)) ' size A01 = ' int2str(size(A01))]);
  error(' synA11min - A10 and A01 do not match ');
end
if     n11 == n01
  T=min(A01, stripU(extD(A01, cmax))); 
elseif n11 == n01-1 
  T=min(stripD(A01), stripU(A01)); 
else
  disp([' size A10 = ' int2str(size(A10)) ' size A01 = ' int2str(size(A01))]);
  error(' synA11min - A10 and A01 do not match ');
end  
%Note: all(size(S) == size(T)) & all(size(S) == [n11 m11]) always holds.
A11=min(S, T);
%-----------------------------------------------------------------------------
