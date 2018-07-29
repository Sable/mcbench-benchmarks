function X = QLiftRec2(C, S, filtername)
%-----------------------------------------------------------------------------
% QLiftRec2
% Multilevel 2-D reconstruction by inverting the lifting scheme and using
% quincunx grids
%
% Syntax: X = QLiftRec2(C, S, filtername)
%
% QLiftRec2 performs the reconstruction of a two-dimensional signal (matrix, 
% image) X by inverting the lifting scheme using prediction and update filters
% that are indicated by filtername.
% The reconstruction involves the vector of coefficients C and the bookkeeping
% matrix S. The structure and dimensions of C and S are supposed to be 
% consistent with how they are produced by QLiftDec2.
% QLiftRec2 is the inverse function of QLiftDec2.
% filtername is supposed to be the same string as chosen for QLiftDec2.
%
% Output X is a two-dimensional signal (image).
%
% Calls for: QLiftRec2Nevill, QLiftRec2MaxMin, QLiftRec2MinMin, QLiftRec2MaxMax  
%
% See also: QLiftDec2 
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 17, 2003.
% (c) 1999-2003 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
% Note: future argument list of this function might be extended with an 
% argument that points to another level than 1, nargin could be checked 
% for this.
if isempty(C)
  error(' QLiftRec2 - empty decomposition ');
else
  if isempty(S)
    error(' QLiftRec2 - empty bookkeeping ');
  else
    if strncmpi(filtername,'Neville',7)
       X = QLiftRec2Nevill(C,S,filtername);
    elseif strncmpi(filtername,'MaxMin',6)
       X = QLiftRec2MaxMin(C,S);
    elseif strncmpi(filtername,'MinMin',6)
       X = QLiftRec2MinMin(C,S);
    elseif strncmpi(filtername,'MaxMax',6)
       X = QLiftRec2MaxMax(C,S);
%   elseif strncmpi(filtername,'some',4)
%      stencilP = something;
%      centerP =  something;
%      stencilU = something;
%      centerU =  something;
%      X = QLiftRec2Custom(C, S, stencilP, centerP, stencilU, centerU);
    else
       error([' QLiftRec2 - unknown filter ' filtername]);
    end
  end
end
%
%-----------------------------------------------------------------------------
