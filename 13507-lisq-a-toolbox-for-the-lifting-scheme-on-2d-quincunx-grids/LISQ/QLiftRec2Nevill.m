function X = QLiftRec2Nevill(C, S, filtername)
%-----------------------------------------------------------------------------
% QLiftRec2Nevill
% Multilevel 2-D reconstruction by inverting the lifting scheme and using 
% quincunx grids
%
% Calls for: NevilleR2Q, stencilR2Q, stencilCrop, stencilxgridfRVC,
%            retrieveQ1001, retrieveR,
%            getcolor01, getcolor10, getcolor00, getcolor11,
%            putcolor01, putcolor10, putcolor00, putcolor11.        
% See also: QLiftDec2 
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: May 16, 2002.
% (c) 1999-2002 Stichting CWI, Amsterdam
%-----------------------------------------------------------------------------
% Note: argument list of this function might be extended with an argument that
%       points to another level than 1, nargin could be checked for this.
%Firstly, check input data
%
if isempty(C)
  error(' QLiftRec2Nevill - empty decomposition ');
else
  if isempty(S)
    error(' QLiftRec2Nevill - empty bookkeeping ');
  end
end
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
     error([' QLiftRec2Nevill - unknown filter ' filtername]);
end
%
[nS, mS] = size(S);
if mS ~= 6
  error(' QLiftRec2Nevill - books do not fit ');
end
N = S(nS,1); 
if mod(N, 2) == 1
  error(' QLiftRec2Nevill - only an even number of levels is accepted ');
end
  if N < 2
    disp([' QLiftRec2Nevill - WARNING too few levels present ' ...
          '-> empty reconstruction ']);
    X = [];          
  end
%
%Secondly, some initializing (see also QLiftDec2)
%
Ua = 0.5 * Pa; centerUa = centerPa;
%
[Pb, centerPb] = stencilR2Q(Pa, centerPa);
[Pb, centerPb] = stencilCrop(Pb, centerPb);
Ub = 0.5 * Pb; centerUb = centerPb;
%
%Thirdly, start reconstruction
%
for lev=N:-2:1
%
%  The Inverse Scheme proceeds from rectangular grid to quincunx grid.
   if lev >= N
     APPROX00 = retrieveR(lev, 'a', C, S);     % "even slots"
   end
   DETAIL11 = retrieveR(lev, 'd', C, S);       % "odd slots"
%
%  Stage: undo update
   sizeQ = size(APPROX00) + size(DETAIL11);
   Q0011A00 = APPROX00 - ...
      getcolor00(stencilxgridfRVC(putcolor11(DETAIL11, sizeQ), Ub, centerUb));
   clear APPROX00;      
%
%  Stage: undo predict
   RectApprox = putcolor00(Q0011A00, sizeQ);
   Q0011A11 = DETAIL11 + getcolor11(stencilxgridfRVC(RectApprox, Pb, centerPb));
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
   sizeR = size(DETAIL10) + size(DETAIL01);
   RectDetail = putcolor10(DETAIL10, sizeR) + putcolor01(DETAIL01, sizeR);
   UaD = stencilxgridfRVC(RectDetail, Ua, centerUa);
%  Note: the operations count is twice as much as it could be.   
   clear RectDetail;   
   Q0011A00 = Q0011A00 - getcolor00(UaD);
   Q0011A11 = Q0011A11 - getcolor11(UaD);
   clear UaD;
%
%  Stage: undo predict
   RectApprox = putcolor00(Q0011A00, sizeR) + putcolor11(Q0011A11, sizeR);
   PaQR = stencilxgridfRVC(RectApprox, Pa, centerPa);
%  Note: the operations count is twice as much as it could be.   
   clear RectApprox;  
   Q1001A10 = DETAIL10 + getcolor10(PaQR);
   Q1001A01 = DETAIL01 + getcolor01(PaQR);
   clear DETAIL10 DETAIL01 PaQR;
%
%  Merge
   APPROX00 = putcolor00(Q0011A00, sizeR) + putcolor11(Q0011A11, sizeR) + ...
              putcolor10(Q1001A10, sizeR) + putcolor01(Q1001A01, sizeR);
%  APPROX00 is used in the next iteration of the "for"-loop!
   clear Q0011A00 Q0011A11 Q1001A10 Q1001A01;
%   
%  Warning: not yet verified whether sizeQ and sizeR will be consistent for all
%           possible griddimensions of original image. 
%
   if (lev-1) == 1
     X = APPROX00; clear APPROX00;
   end
end
%-----------------------------------------------------------------------------
