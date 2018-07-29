function C = getcolor11(A)
%------------------------------------------------------------------------------
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: June 6, 1999.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n, m] = size(A);
C=A(2:2:n, 2:2:m);
%------------------------------------------------------------------------------
