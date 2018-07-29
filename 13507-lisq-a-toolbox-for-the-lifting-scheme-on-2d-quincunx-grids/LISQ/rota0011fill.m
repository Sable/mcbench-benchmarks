function Q = rota0011fill(A00, A11, bgval)
%------------------------------------------------------------------------------
%
% The quincunx grid as constituted by A00 and A11 is rotated and mapped
% onto a rectangular grid together with the corresponding values.
% The excess area is filled by padding with value bgval if explicitly
% desired, else with the first value of A00. Note that the latter
% choice doesn't change neither the minimum nor maximum of the
% gridfunctions.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: April 7, 2003.
% (c) 1999-2003 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n00, m00]=size(A00);
[n11, m11]=size(A11);
if n11 > n00
  error(' rota0011fill - dimensions do not match for n11 > n00 ')
end 
if m11 > m00
  error(' rota0011fill - dimensions do not match for m11 > m00 ')
end 
if n00 > n11+1
  error(' rota0011fill - dimensions do not match for n00 > n11+1 ')
end 
if m00 > m11+1
  error(' rota0011fill - dimensions do not match for m00 > m11+1 ')
end 
%
% m11 <= m00 <= m11+1 is satisfied
% n11 <= n00 <= n11+1 is satisfied
%
if nargin == 3
  c = bgval;
elseif nargin == 2
  c = A00(1,1);
else
  error(' rota0011fill - number of arguments should be either 2 or 3 ')
end
nQ = m00 - 1 + max([n00 n11]);
mQ = max([(n00+m00-1) (n11+m11)]);
Q  = reshape(linspace(c,c,nQ*mQ),nQ,mQ);
%
for j=1:m00
   for i=1:n00
      iq=  i - j + m00;
      jq=  i + j - 1;
      Q(iq,jq)=A00(i,j);
   end
end
%
for j=1:m11
   for i=1:n11
      iq=  i - j + m00;
      jq=  i + j;
      Q(iq,jq)=A11(i,j);
   end
end   
%------------------------------------------------------------------------------
