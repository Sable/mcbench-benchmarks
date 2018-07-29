function X = QLiftRec2MaxMax(C, S)
%-----------------------------------------------------------------------------
% QLiftRec2MaxMax 
% Multilevel 2-D reconstruction by inverting the lifting scheme and using
% quincunx grids.
%
% The MaxMax scheme has been proposed by Heijmans and Goutsias, see e.g.
%    H.J.A.M. Heijmans, J. Goutsias,
%    Multiresolution signal decomposition schemes.
%    Part 2: morphological wavelets.
%    CWI Report PNA-R9905, Amsterdam, 1999.
%    http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04625D.pdf
%
% Calls for: 
%            retrieveQ1001, retrieveR,
%            getcolor01, getcolor10, getcolor00, getcolor11,
%            putcolor01, putcolor10, putcolor00, putcolor11.        
% See also: QLiftDec2MaxMin, QLiftRec2 
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 6, 2003.
% (c) 1999-2002 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
% Note: argument list of this function might be extended with an argument that
%       points to another level than 1, nargin could be checked for this.
% Firstly, check input data
%
if isempty(C)
  error(' QLiftRec2MaxMax - empty decomposition ');
else
  if isempty(S)
    error(' QLiftRec2MaxMax - empty bookkeeping ');
  end
end
%
N = numoflevs(S); 
if mod(N, 2) == 1
  error(' QLiftRec2MaxMax - only an even number of levels is accepted ');
end
%
%Secondly, start reconstruction
%
for lev=N:-2:1
%
%  The Inverse Scheme proceeds from rectangular grid to quincunx grid.
   if lev >= N
     APPROX00 = retrieveR(lev, 'a', C, S);     % "even slots"
   end
   DETAIL11 = retrieveR(lev, 'd', C, S);       % "odd slots"
   minO = min( min(min(APPROX00)), min(min(DETAIL11)) );
   maxO = max( max(max(APPROX00)), max(max(DETAIL11)) );
   cmin = minO-(maxO-minO);
%  cmax = maxO+(maxO-minO);
%
%  Stage: undo update
   sizeA00 = size(APPROX00);
   Q0011A00 = APPROX00 - ...
              max(zeros(sizeA00), synA00Qmax(DETAIL11, sizeA00, cmin));
   clear APPROX00 sizeA00;      
%
%  Stage: undo predict
   Q0011A11 = DETAIL11 + synA11Qmax(Q0011A00, size(DETAIL11), cmin);
   clear DETAIL11; 
%     
%  Merge
%  The union Q0011 of Q0011A00 & Q0011A11 now contains the approximation on 
%  the next scale (with index lev-1).
%
%  The Inverse Scheme proceeds from quincunx grid to rectangular grid.
%
%  The "even slots" are in the colours 00 and 11,
%  the "odd slots"  are in the colours 10 and 01.
%
%  Stage: undo update
   [DETAIL10, DETAIL01] = retrieveQ1001(lev-1, 'd', C, S);
   A00 = Q0011A00 - ...
         max(zeros(size(Q0011A00)), synA00max(DETAIL10, DETAIL01, cmin));
   clear Q0011A00; 
   A11 = Q0011A11 - ...
         max(zeros(size(Q0011A11)), synA11max(DETAIL10, DETAIL01, cmin));
   clear Q0011A11;         
%
%  Stage: undo predict  
   A10 = DETAIL10 + synA10max(A11, A00, cmin);
   A01 = DETAIL01 + synA01max(A11, A00, cmin);
   sizeR = size(DETAIL10) + size(DETAIL01);
   clear DETAIL10 DETAIL01;
%
%  Merge
   APPROX00 = putcolor00(A00, sizeR) + putcolor11(A11, sizeR) + ...
              putcolor10(A10, sizeR) + putcolor01(A01, sizeR);
%  APPROX00 is used in the next iteration of the "for"-loop!
   clear A00 A11 A10 A01;
%   
%  Warning: not yet verified whether sizeQ and sizeR will be consistent for all
%           possible griddimensions of original image. 
%
   if (lev-1) == 1
     X = APPROX00; clear APPROX00;
   end
end
%-----------------------------------------------------------------------------
