function Q = rota1001fill(A10, A01, bgval)
%------------------------------------------------------------------------------
%
% The quincunx grid as constituted by A10 and A01 is rotated and mapped
% onto a rectangular grid together with the corresponding values.
% The excess area is filled by padding with value bgval if explicitly
% desired, else with the first value of A10. Note that the latter
% choice doesn't change neither the minimum nor maximum of the gridfunctions.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: April 7, 2003.
% (c) 1999-2003 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n10, m10]=size(A10);
[n01, m01]=size(A01);
if m01 > m10
  error(' rota1001fill - dimensions do not match for m01 > m10 ')
end 
if n10 > n01
  error(' rota1001fill - dimensions do not match for n10 > n01 ')
end 
if m10 > m01+1
  error(' rota1001fill - dimensions do not match for m10 > m01+1 ')
end 
if n01 > n10+1
  error(' rota1001fill - dimensions do not match for n01 > n10+1 ')
end 
%
% m01 <= m10 <= m01+1 is satisfied
% n10 <= n01 <= n10+1 is satisfied
%
if nargin == 3
  c = bgval;
elseif nargin == 2
  c = A10(1,1);
else
  error(' rota1001fill - number of arguments should be either 2 or 3 ')
end
nQ = n10+m10;
mQ=max([(n10+m10-1) (n01+m01-1)]);
Q=reshape(linspace(c,c,nQ*mQ),nQ,mQ);
%
for j=1:m10
   for i=1:n10
      iq=  i - j + m10 + 1;
      jq=  i + j - 1;
      Q(iq,jq)=A10(i,j);
   end
end
%
for j=1:m01
   for i=1:n01
      iq=  i - j + m10;
      jq=  i + j - 1;
      Q(iq,jq)=A01(i,j);
   end
end   
%------------------------------------------------------------------------------
