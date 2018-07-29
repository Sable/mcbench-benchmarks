function [C, S] = QLiftDec2(X, N, filtername)
%-----------------------------------------------------------------------------
% QLiftDec2
% Multilevel 2-D decomposition by the lifting scheme and using quincunx grids.
%
% Syntax: [C, S] = QLiftDec2(X, N, filtername)
%
% QLiftDec2 performs the N-level decomposition of a two-dimensional signal 
% (matrix, image) X by the lifting scheme using prediction and update filters 
% that are indicated by the string 'filtername'.
% For more information on the underlying algorithm and its backgrounds, see
% http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf
%
% Outputs are the decomposition vector C and the corresponding bookkeeping
% matrix S. At odd levels of the decomposition the coefficients reside on 
% quincunx-shaped grids, at even levels of the decomposition the coefficients
% reside on rectangular grids.
% The decomposition vector C includes all detail coefficients (at levels < N)
% and the coefficients of the approximation (at level = N).
%
% X must be a two-dimensional array, the dimensions need NOT be dyadic.
%
% N must be a strictly positive and even integer.
%
% filtername must be a string from the set:
% {Neville2, Neville4, Neville6, Neville8, MaxMin, MinMin, MaxMax}
% The first four filters of this set are linear ones and of increasing order.
% The last three filters are nonlinear ones. The corresponding lifting schemes
% are better in preserving edges and local maxima and/or minima.
% MaxMax preserves local maxima, MinMin local minima, MaxMin is a compromise
% between MaxMax and MinMin. For more information on the nonlinear filters see
% http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04625D.pdf
%
% See also: QLiftRec2, QLiftDec2Nevill, QLiftDec2MaxMin, QLiftDec2MinMin,
%           QLiftDec2MaxMax.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 17, 2003.
% (c) 1999-2003 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
%
C = []; S = [];
if isempty(X)
  error(' QLiftDec2 - empty matrix ');
else
  if strncmpi(filtername,'Neville',7)
     [C, S] = QLiftDec2Nevill(X, N, filtername);    
  elseif strncmpi(filtername,'MaxMin',6)
     [C, S] = QLiftDec2MaxMin(X, N);
  elseif strncmpi(filtername,'MinMin',6)
     [C, S] = QLiftDec2MinMin(X, N);
  elseif strncmpi(filtername,'MaxMax',6)
     [C, S] = QLiftDec2MaxMax(X, N);
% elseif strncmpi(filtername,'something',4)
%    stencilP = something;
%    centerP =  something;
%    stencilU = something;
%    centerU =  something;
%    [C, S] = QLiftDec2Custom(X, N, stencilP, centerP, stencilU, centerU);
  else
     error([' QLiftDec2 - unknown filter ' filtername]);
  end
end
%
%-----------------------------------------------------------------------------
