function [H, L] = storeQ1001( F10, F01, levelF, o, H, L)
%------------------------------------------------------------------------------
%
% Gridfunctions F10 and F01 are supposed to be elements of two different
% colours of an extended gridfunction. As such, F10 and F01 together
% constitute a quincunx gridfunction.
% This function stores F10 and F01 (separately) for future extraction.
% Properties and location are stored in the bookkeeping matrix L.
% This function is a two-dimensional lifting scheme utility.
%
%                H   H   H   H  
%              V   V   V   V   V       V ~ F10
%                H   H   H   H         H ~ F01
%              V   V   V   V   V
%                H   H   H   H  
%              V   V   V   V   V
%                H   H   H   H  
%              V   V   V   V   V
%                H   H   H   H  
%       (domain of quincunx gridfunction)
%
% F10 = 2D gridfunction of colour '10'
%
% F01 = 2D gridfunction of colour '01'
%
% levelF = integer designated as the level of both F10 and F01
%
% o = character, should be either 'a' or 'd',
%     describing the type of both F10 and F01:
%     'a' relates to approximation (coefficients) and
%     'd' relates to detail (coefficients)
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
% H = 1D array that functions as storage (heap). The coefficients of F10 &
%     F01 are appended to H as a result of calling storeQ1001. Bookkeeping is
%     maintained in L. No attention of the user is required.
%
% See also: retrieveQ1001, retrieveQ0110, storeQ, storeQ0011, storeQ1100
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 8, 2001.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
[n10, m10]=size(F10);
[n01, m01]=size(F01);
if m01 > m10
  error(' storeQ1001 - dimensions do not match for m01 > m10 ')
end 
if n10 > n01
  error(' storeQ1001 - dimensions do not match for n10 > n01 ')
end 
if m10 > m01+1
  error(' storeQ1001 - dimensions do not match for m10 > m01+1 ')
end 
if n01 > n10+1
  error(' storeQ1001 - dimensions do not match for n01 > n10+1 ')
end 
%
% m01 <= m10 <= m01+1 is satisfied
% n10 <= n01 <= n10+1 is satisfied
%
[H, L] = storeQ( F10, levelF, '10', o, H, L);
[H, L] = storeQ( F01, levelF, '01', o, H, L);
%------------------------------------------------------------------------------

