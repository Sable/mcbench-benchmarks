function lev = QLmaxlev(sizeX, filtername)
%-----------------------------------------------------------------------------
% QLmaxlev
% This function determines the maximum level possible for the QL-schemes.
%
% Syntax: lev = QLmaxlev(sizeX, filtername)
%
% QLmaxlev is a utility for the lifting scheme decomposition. It helps one to 
% avoid silly values for the maximum level in the lifting scheme decomposition.
% 
% lev is the integer outcome.
% 
% sizeX is an integer row vector of dimension 2. Usually it will be the size of
% an image.
%
% filtername must be a string from the set:
% {Neville2, Neville4, Neville6, Neville8, MaxMin, MinMin, MaxMax}
%
% See also: QLiftDec2, QLiftRec2, wmaxlev
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 17, 2003.
% (c) 1999-2003 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
%Firstly, check input data
if nargin ~= 2
  error(' QLmaxlev - number of arguments should be 2 ');
end
if ~ischar(filtername)
  error(' QLmaxlev - format of filtername should be character array ');
end
%
switch lower(filtername)
 case 'neville2'
   diam =  3;
 case 'neville4'
   diam =  5;
 case 'neville6'
   diam =  7;
 case 'neville8'
   diam = 11;
 case 'maxmin'
   diam =  3;
 case 'maxmax'
   diam =  3;
 case 'minmax'
   diam =  3;
 case 'minmin'
   diam =  3;
 otherwise
   error(' QLmaxlev - unknown filter ')
end
%
if isempty(sizeX)
  lev = [];
  return;
else
  lev=0;
  n=min(sizeX);
  z=2*diam-1;
  while z<=n
    lev=lev+2;
    z=2*z-1;
  end
end
%-----------------------------------------------------------------------------
