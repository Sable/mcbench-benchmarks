function [C, S] = QLiftDec2Nevill(X, N, filtername)
%-----------------------------------------------------------------------------
% QLiftDec2Nevill
% Multilevel 2-D decomposition by the lifting scheme and using quincunx grids
%
% Calls for: NevilleR2Q, stencilR2Q, stencilCrop, stencilxgridfRVC, QLmaxlev,
%            storeQ1001, storeR,
%            getcolor01, getcolor10, getcolor00, getcolor11,
%            putcolor01, putcolor10, putcolor00, putcolor11.        
% See also: QLiftRec2NV
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: May 16, 2002.
% (c) 1999-2002 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
%Firstly, check input data
%
if  isempty(X)
  error(' QLiftDec2Nevill - empty matrix ');
else
  if mod(N, 2) == 1
    error(' QLiftDec2Nevill - only an even number of levels is accepted ');
  end
  if QLmaxlev(size(X), filtername) < N
    error(' QLiftDec2Nevill - too many levels requested ');
  end
  if N < 2
    disp([' QLiftDec2Nevill - WARNING too few levels requested ' ...
          '-> empty decomposition ']);
  end
end
C = []; S = [];
%
%Secondly, some initializing of filters
%
switch lower(filtername)
 case 'neville2'
   [Pa, centerPa] = NevilleR2Q(2);
 case 'neville4'
   [Pa, centerPa] = NevilleR2Q(4);
 case 'neville6'
   [Pa, centerPa] = NevilleR2Q(6);
 case 'neville8'
   [Pa, centerPa] = NevilleR2Q(8);
 otherwise
   error([' QLiftDec2Nevill - unknown filter ' filtername]);
end
%
% Here Pa is the stencil of a prediction step,
% e.g. Pa = 0.250*[0 1 0; 1 0 1; 0 1 0]; centerPa = [2 2];
%
Ua = 0.5 * Pa; centerUa = centerPa;
% Ua is the stencil of the update step and as such determined by Pa.
%
[Pb, centerPb] = stencilR2Q(Pa, centerPa);
[Pb, centerPb] = stencilCrop(Pb, centerPb);
% where Pb is the stencil of a prediction step,
% e.g. Pb = 0.250*[1 0 1; 0 0 0; 1 0 1]; centerPb = [2 2];
%
Ub = 0.5 * Pb; centerUb = centerPb; % Compare to V11!!,
%                                     what about center of stencil??
% Ub is the stencil of the update step and as such determined by Pb.
%
%Thirdly, start decomposition
%
O = X; % For the sake of efficient use of memory this could be improved upon.
% We descend to coarser grids, integer lev indicates number of scale.

for lev=1:2:N
%
   [nO, mO] = size(O);
   if ( nO < 3 ) || ( mO < 3)
     error(' QLiftDec2Nevill - too many levels ');
   else
     sizeO = size(O);
   end
%
%  The Lifting Scheme proceeds from a rectangular grid
%  towards a quincunx grid.
%
%  Stage: predict
%  Convolution of prediction stencil Pa with WHOLE gridfunction O.
%  Note: the operations count is twice as much as it could be.
   PaO = stencilxgridfRVC(O, Pa, centerPa);
%
%  Quincunx grid Q0011 is the union of the values at .00 and .11: "even slots"
%  Quincunx grid Q1001 is the union of the values at .10 and .01: "odd slots"
   Q1001D01 = getcolor01(O) - getcolor01(PaO);
   Q1001D10 = getcolor10(O) - getcolor10(PaO);
   clear PaO;
%  At this point the union (quincunx) of Q1001D01 & Q1001D10
%  contains the DETAILS of O.
%  Note: this is not an "in place" implementation.
%  For the inverse transform Q1001D01 and Q1001D10 have to be stored:
   [C, S] = storeQ1001( Q1001D10, Q1001D01, lev, 'd', C, S);
%
%  Stage: update
   RectDetail = putcolor10(Q1001D10, sizeO) + putcolor01(Q1001D01, sizeO);
   clear Q1001D01 Q1001D10;
   UaD = stencilxgridfRVC(RectDetail, Ua, centerUa);
   clear RectDetail;
%
   Q0011A00 = getcolor00(O) + getcolor00(UaD);
   Q0011A11 = getcolor11(O) + getcolor11(UaD);
   clear UaD O;
%
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
   DETAIL11 = Q0011A11 - ...
      getcolor11(stencilxgridfRVC(putcolor00(Q0011A00, sizeO), Pb, centerPb));
   clear Q0011A11;       
%  Note: the operations count is twice as much as it could be
%  DETAIL11 presents the detail gridfunction w.r.t. Q0011
%
%  For the inverse transform DETAIL11 has to be stored:
   [C, S] = storeR( DETAIL11, lev+1, 'd', C, S);
%
%  Stage: update
%  Break up next line in parts in case checking is desired
   APPROX00 = Q0011A00 + ...
      getcolor00(stencilxgridfRVC(putcolor11(DETAIL11, sizeO), Ub, centerUb));
   clear Q0011A00 DETAIL11;     
%  APPROX00 now represents the updated version of the approximation of Q0011
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
