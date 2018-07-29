function [first, last] = whatcoef2QL(level, colorF, o, L)
%------------------------------------------------------------------------------
%
% This function determines where to find a 2D gridfunction in the
% 1D storage vector (heap).
% The output is the first and last index within the heap.
% They are supposed to be uniquely determined by the integer level L and
% character o describing the type of the 2D gridfunction.
%
% This function is a two-dimensional lifting scheme utility.
%
% first = integer
%
% last  = integer
%
% level = integer designated as the level of the 2D gridfunction
%
% o = character, should be either 'a' or 'd',
%     describing the type of the 2D gridfunction:
%     'a' relates to approximation (coefficients) and
%     'd' relates to detail (coefficients)
%
% L = 2D integer array of bookkeeping, see function storeR.
%
% See also: storeR, retrieveQ etc.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: May 22, 2002.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
if isempty(L)
  first = 1;
  last  = 0;
else
  [nL, mL] = size(L);
  if mL ~= 6
    disp([' whatcoef2QL - ERROR at type ' o ' level ' num2str(level)]);
    error(' whatcoef2QL - books do not fit ')
  else   
%   Choose here according to level
    lo1 = lower(o(1));
    if mod(level, 2) == 0
%     At even level the grids are rectangular
      jL = -1;
      j = 1;
      foundit = 0;
      while j <= nL && ~foundit
         if L(j, 1) == level
           switch lo1
             case 'a' , if L(j, 3) == 0 && L(j, 2) == 0
                          jL = j;
                          foundit = 1;
                        end
             case 'd' , if L(j, 3) == 1 && L(j, 2) == 0 
                          jL = j;
                          foundit = 1;
                        end
             otherwise
               disp([' whatcoef2QL - ERROR at type ' o ...
                     ' level ' num2str(level)]);
               error(' whatcoef2QL - unknown type of coefficients ')
           end         
         end
         j = j + 1;
      end
      if jL == -1
        disp([' whatcoef2QL - ERROR at type ' lo1 ' level ' num2str(level)]);
        error(' whatcoef2QL - no such coefficients in heap')
      else
        nF = L(jL, 4);
        if nF < 1
          disp([' whatcoef2QL - ERROR at type ' lo1 ' level ' num2str(level)]);
          error(' whatcoef2QL - unvalid 1st dimension of target')
        end
        mF = L(jL, 5);
        if mF < 1
          disp([' whatcoef2QL - ERROR at type ' lo1 ' level ' num2str(level)]);
          error(' whatcoef2QL - unvalid 2nd dimension of target')
        end 
        heaptr = L(jL, 6);
        if heaptr < 2
          disp([' whatcoef2QL - ERROR at type ' lo1 ' level ' num2str(level)]);
          error(' whatcoef2QL - bookkeeping error ')
        else
          first = heaptr-nF*mF;
          if first < 1
            disp([' whatcoef2QL - ERROR at type ' lo1 ' level ' num2str(level)]);
            error(' whatcoef2QL - heap not that large, dimensions?')
          else
            last  = heaptr-1;
          end
        end
      end       
    else
%     At odd level the grids are quincunx-shaped.
      switch colorF 
        case '00' , icolorF = 1;
        case '11' , icolorF = 2;
        case '01' , icolorF = 3;
        case '10' , icolorF = 4;
        otherwise
          disp([' whatcoef2QL - ERROR at type ' lo1 ' color ' colorF ...
                ' with level ' num2str(level)]);
          error(' whatcoef2QL - unknown type of coefficients ')          
      end
      fix2even = 999;
      FL = [];
      for j=1:nL
        if L(j, 2) == icolorF
           FL = [FL; [ (L(j,1)+fix2even) 0 L(j,3:6)]];
        end
      end
      if isempty(FL)
        first = 1;
        last  = 0;
      else
        [first, last] = whatcoef2QL((level+fix2even), colorF, lo1, FL);
%       Here colorF does not matter as (level+fix2even) is even.
      end           
    end            
  end
end
%------------------------------------------------------------------------------
