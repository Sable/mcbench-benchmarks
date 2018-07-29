function [H, L] = storeR( F, levelF, o, H, L)
%------------------------------------------------------------------------------
% 
% This function stores a two-dimensional gridfunction F into H for
% future extraction. Properties and location are stored in the book-
% keeping matrix L.
% This function is a two-dimensional lifting scheme utility. 
% 
% F = 2D gridfunction of coefficients
% 
% levelF = integer designated as the level of F
% 
% o = character, should be either 'a' or 'd',
%     describing the type of F:
%     'a' relates to approximation (coefficients) and
%     'd' relates to detail (coefficients)
%     other characters 'n' may be added to this list infuture versions
%
% L = 2D integer array of bookkeeping, its contents are updated by calls
%     to functions as storeQ, storeQ.... and does not require the
%     attention of the user.
%     L is organised as follows:
%       (for the j-th gridfunction F appended to H)
%       L(j, 1) = level of F as it has been assigned by the user.
%       L(j, 2) = 0 means that F corresponds to a rectangular domain,
%                   storeR always assigns this value. Functions like
%                   storeQ, storeQ.... assign values other than 0.
%       L(j, 3) = 0 stands for approximation type coefficients, 'a',
%                 1 stands for detail type coefficients, 'd'.
%       L(j, 4) = (integer) 1st dimension of gridfunction F.
%       L(j, 5) = (integer) 2nd dimension of gridfunction F.
%       L(j, 6) = integer that points to the end of the j-th
%                 addition to the heap.
%     With each call to storeR, storeQ, storeQ.... L obtains additional
%     row(s).
%
% H = 1D array that functions as storage (heap). The coefficients of F
%     are appended to H as a result of calling storeR. Bookkeeping is
%     maintained in L. No attention of the user is required.
% 
% See also: retrieveR, storeQ
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 12, 2001.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
addend = [0 0 0 0 0 0];
if isempty(L)
  if ~isempty(H)
    error(' storeR - books empty but heap is not ')
  else 
    nL = 0;
%   mL = 6;
    heaptr = 1;
  end
else
  if isempty(H)
    error(' storeR - books not empty but heap is ')
  else
    [nL, mL] = size(L); 
    if mL ~= 6
      error(' storeR - books do not fit ')
    else
      heaptr = L(nL, 6);
      if heaptr < 2
        error(' storeR - bookkeeping error ')
      end
    end
  end
end
%
L = [L; addend];
nL = nL + 1;
%
L(nL, 1) = levelF;
L(nL, 2) = 0;
switch o
    case 'a' , L(nL, 3) = 0;
    case 'd' , L(nL, 3) = 1;
%   case 'n' , L(nL, 3) = 2;
    otherwise
        error(' storeR - unknown type of coefficients ')
end
if isempty(F)
  error(' storeR - addition is empty ')
else
  [nF, mF] = size(F);
end
L(nL, 4) = nF;
L(nL, 5) = mF;
L(nL, 6) = heaptr + nF * mF;
%
H = addtoheap(F, H);
%------------------------------------------------------------------------------
