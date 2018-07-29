function N = numoflevs(L)
%------------------------------------------------------------------------------
%
% Extracts the number of levels from the array of bookkeeping.
%
% L = 2D integer array of bookkeeping.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 11, 2001.
%  2001-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[nL, mL] = size(L);
if mL ~= 6
  error(' numoflevs - books do not fit ');
end
N = L(nL,1);
if N < 1
  error(' numoflevs - the number of levels should be at least one ');
end
%------------------------------------------------------------------------------
