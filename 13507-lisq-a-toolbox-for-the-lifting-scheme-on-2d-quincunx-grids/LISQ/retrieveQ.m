function F = retrieveQ(level, colorF, o, H, L)
%------------------------------------------------------------------------------
%
% This function extracts gridfunction F of colour colorF from heap H.
% F is supposed to be uniquely determined by the integer L (level) and
% character o describing its type. F is defined on a rectangular
% domain.
% This function is a two-dimensional lifting scheme utility.
%
% F = 2D gridfunction of coefficients extracted from H.
%
% level = integer designated as the level of F.
%
% colorF = colour of F, for a description see function storeQ.
%
% o = character, should be either 'a' or 'd',
%     describing the type of F:
%     'a' relates to approximation (coefficients) and
%     'd' relates to detail (coefficients)
%
% L = 2D integer array of bookkeeping, for a description see function storeQ.
%
% H = 1D array that functions as storage (heap). The coefficients of F
%     are extracted from H as a result of calling retrieveQ.
%
% See also: storeQ, retrieveR
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 12, 2001.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
if isempty(L) || isempty(H)
  F = [];
else
  FL = [];
  [nL, mL] = size(L);
  if mL ~= 6
    disp([' retrieveQ - ERROR at type ' o ' color ' colorF ...
          ' with level ' num2str(level)]);
    error(' retrieveQ - books do not fit ')
  end    
  switch colorF
      case '00' , icolorF = 1;
      case '11' , icolorF = 2;
      case '01' , icolorF = 3;
      case '10' , icolorF = 4;
      otherwise
          disp([' retrieveQ - ERROR at type ' o ' color ' colorF ...
                ' with level ' num2str(level)]);
          error(' retrieveQ - unknown type of coefficients ')          
  end
  for j=1:nL
    if L(j, 2) == icolorF
      FL = [FL; [ L(j,1) 0 L(j,3:6)]];
    end
  end
  if isempty(FL)
    F = [];
  else
    F = retrieveR(level, o, H, FL);
  end
end
%------------------------------------------------------------------------------
