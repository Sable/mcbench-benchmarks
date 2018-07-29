function [C, S] = QLiftDec2MinMin(X, N)
%-----------------------------------------------------------------------------
% QLiftDec2MinMin
% Multilevel 2-D decomposition by the lifting scheme and using quincunx grids
%
% The MinMin scheme has been proposed by Heijmans and Goutsias, see e.g.
%    H.J.A.M. Heijmans, J. Goutsias,
%    Multiresolution signal decomposition schemes.
%    Part 2: morphological wavelets.
%    CWI Report PNA-R9905, Amsterdam, 1999.
%    http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04625D.pdf
%
% Calls for: QLmaxlev,
%            storeQ1001, storeR,
%            getcolor01, getcolor10, getcolor00, getcolor11,
%            putcolor01, putcolor10, putcolor00, putcolor11.        
% See also: QLiftRec2MaxMin
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 3, 2003.
% (c) 1999-2003 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
%Firstly, check input data
%
if  isempty(X)
  error(' QLiftDec2MinMin - empty matrix ');
else
  if mod(N, 2) == 1
    error(' QLiftDec2MinMin - only an even number of levels is accepted ');
  end
  if QLmaxlev(size(X), 'minmin') < N 
    error(' QLiftDec2MinMin - too many levels requested ');
  end
  if N < 2
    disp([' QLiftDec2MinMin - WARNING too few levels requested ' ...
          '-> empty decomposition ']);
  end
end
%
%Secondly, start decomposition
%
O = X; % For the sake of efficient use of memory this could be improved upon.
% We descend to coarser grids, integer lev indicates number of scale.
C = []; S = [];

for lev=1:2:N
%
   [nO, mO] = size(O);
   if ( nO < 3 ) || ( mO < 3)
     error(' QLiftDec2MinMin - too many levels ');
   end
   minO = min(min(O));
   maxO = max(max(O));
%  cmin = minO-(maxO-minO);
   cmax = maxO+(maxO-minO);
%
%  The Lifting Scheme proceeds from a rectangular grid
%  towards a quincunx grid.
%
%  Stage: predict
   A00 =getcolor00(O);
   A11 =getcolor11(O);
%  Quincunx grid Q0011 is the union of the values at .00 and .11: "even slots"
%  Quincunx grid Q1001 is the union of the values at .10 and .01: "odd slots"
   Q1001D01 = getcolor01(O) - synA01min(A11, A00, cmax);                % Y1
   Q1001D10 = getcolor10(O) - synA10min(A11, A00, cmax);                % Y1
%  At this point the union (quincunx) of Q1001D01 & Q1001D10
%  contains the DETAILS of O.
%
%  For the inverse transform Q1001D01 and Q1001D10 have to be stored:
   [C, S] = storeQ1001( Q1001D10, Q1001D01, lev, 'd', C, S);
%
%  Stage: update
   Q0011A00 = A00 + ...
        min(zeros(size(A00)), synA00min(Q1001D10, Q1001D01, cmax));     % X1
   clear A00;
   Q0011A11 = A11 + ...
        min(zeros(size(A11)), synA11min(Q1001D10, Q1001D01, cmax));     % X1
   clear A11 Q1001D10 Q1001D01;   
%  At this point the union (quincunx) of Q0011A00 & Q0011A11
%  contains the updated APPROXIMATION of O, the DETAILS of O
%  were in the union (quincunx) of Q1001D01 & Q1001D10 (see above).
%
%  The Lifting Scheme proceeds by a subsequent step from quincunx
%  to rectangular grid.
%
%  Q0011 is split into the 11 colour with the "odd slots" and 
%  the 00 colour with the "even slots".
%
%  Stage: predict
   DETAIL11 = Q0011A11 - synA11Qmin(Q0011A00, size(Q0011A11), cmax);        % Y2
   clear Q0011A11;
%  Stage: update
   APPROX00 = Q0011A00 + ...
     min(zeros(size(Q0011A00)), synA00Qmin(DETAIL11, size(Q0011A00), cmax));% X2
%
%  DETAIL11 presents the detail gridfunction w.r.t. Q0011
%  APPROX00 now represents the updated version of the approximation of Q0011
%
%  For the inverse transform DETAIL11 has to be stored:
   [C, S] = storeR( DETAIL11, lev+1, 'd', C, S);
   clear Q0011A00 DETAIL11;     
% 
%  At this point gridfunction DETAIL11 containing the DETAILS has been stored,
%  gridfunction APPROX00 contains the updated APPROXIMATION, on the (down-
%  sampled) rectangular grid and has to be stored as well if at the highest
%  scale.
%  Note that APPROX00 is downsampled onto a rectangular grid with dimensions of 
%  half size of the original O.
   if lev+1 >= N
     [C, S] = storeR(APPROX00, lev+1, 'a', C, S);
%    It is obligatory that at least at one scale the Approximation has to be
%    stored or else the scheme cannot be inverted.
     clear APPROX00;
%    In the Lifting Scheme all scales have now been processed!
   else
%    We proceed to the next scale.
     O = APPROX00; clear APPROX00;
   end   
end
%-----------------------------------------------------------------------------
