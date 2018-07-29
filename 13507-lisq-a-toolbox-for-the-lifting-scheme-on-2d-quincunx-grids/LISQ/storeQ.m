function [H, L] = storeQ( F, levelF, colorF, o, H, L)
%------------------------------------------------------------------------------
%
% Gridfunction F is supposed to correspond to elements of one colour of
% an extended gridfunction. As such, F is a two-dimensional grid-
% function. This function stores F into H for future extraction.
% Properties and location are stored in the bookkeeping matrix L.
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
%
% colorF = string of two characters, should be either '00', '11',
%          '01' or '10'. It describes the colour of F:
%
%     (1,1)             (1,m)
%        O H O H O H O H O
%        V X V X V X V X V
%        O H O H O H O H O              O ~ '00'  (1st colour)
%        V X V X V X V X V              X ~ '11'  (2nd colour)
%        O H O H O H O H O              H ~ '01'  (3rd colour)
%        V X V X V X V X V              V ~ '10'  (4th colour)
%     (n,1)             (n,m)
%          (domain of F)
%
% L = 2D integer array of bookkeeping, its contents are updated by calls
%     to functions as storeQ, storeQ.... and does not require the
%     attention of the user.
%     L is organised as follows:
%       (for the j-th gridfunction F appended to H)
%       L(j, 1) = level of F as it has been assigned by the user.
%       L(j, 2) = stores colour of F
%                 1 corresponds to '00'
%                 2 corresponds to '11'
%                 3 corresponds to '01'
%                 4 corresponds to '10'
%                 0 value assigned by storeR
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
% See also: retrieveQ, storeR
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 12, 2001.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
[H, L] = storeR( F, levelF, o, H, L);
[nL, mL] = size(L);
switch colorF
    case '00' , L(nL, 2) = 1;
    case '11' , L(nL, 2) = 2;
    case '01' , L(nL, 2) = 3;
    case '10' , L(nL, 2) = 4;
    otherwise
                error(' storeQ - unknown type of coefficients ')
end
%------------------------------------------------------------------------------

