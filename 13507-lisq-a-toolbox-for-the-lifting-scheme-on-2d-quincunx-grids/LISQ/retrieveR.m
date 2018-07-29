function F = retrieveR(level, o, H, L)
%------------------------------------------------------------------------------
%
% This function extracts a two-dimensional gridfunction F from H.
% F is supposed to be uniquely determined by the integer level and
% character o describing its type. F is defined on a rectangular
% domain.
% This function is a two-dimensional lifting scheme utility.
%
% F = 2D gridfunction of coefficients extracted from H.
%
% level = integer designated as the level of F.
%
% o = character, should be either 'a' or 'd',
%     describing the type of F:
%     'a' relates to approximation (coefficients) and
%     'd' relates to detail (coefficients)
%
% L = 2D integer array of bookkeeping, see function storeR.
%
% H = 1D array that functions as storage (heap). The coefficients of F
%     are extracted from H as a result of calling retrieveR.
%
% See also: storeR, retrieveQ
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: May 5, 2002.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
if isempty(L)
  if ~isempty(H)
    disp([' retrieveR - ERROR at type ' o ' with level ' num2str(level)]);
    error(' retrieveR - books empty but heap is not ')
  else 
    F = [];
  end
else
  if isempty(H)
    disp([' retrieveR - ERROR at type ' o ' with level ' num2str(level)]);
    error(' retrieveR - books not empty but heap is ')
  else
    [nL, mL] = size(L);
    if mL ~= 6
      disp([' retrieveR - ERROR at type ' o ' level ' num2str(level)]);
      error(' retrieveR - books do not fit ')
    else   
      jL = -1;
      j = 1;
      foundit = 0;
      while j <= nL && ~foundit
         if L(j, 1) == level
           switch o
               case 'a' , if L(j, 3) == 0 && L(j, 2) == 0
                            jL = j;
                            foundit = 1;
                          end
               case 'd' , if L(j, 3) == 1 && L(j, 2) == 0 
                            jL = j;
                            foundit = 1;
                          end
               otherwise
               disp([' retrieveR - ERROR at type ' o ' level ' num2str(level)]);
               error(' retrieveR - unknown type of coefficients ')
           end         
         end
         j = j + 1;
      end
      if jL == -1
        disp([' retrieveR - ERROR at type ' o ' level ' num2str(level)]);
        error(' retrieveR - no such coefficients in heap')
      else
        nF = L(jL, 4);
        if nF < 1
          disp([' retrieveR - ERROR at type ' o ' level ' num2str(level)]);
          error(' retrieveR - unvalid 1st dimension of target')
        end
        mF = L(jL, 5);
        if mF < 1
          disp([' retrieveR - ERROR at type ' o ' level ' num2str(level)]);
          error(' retrieveR - unvalid 2nd dimension of target')
        end 
        heaptr = L(jL, 6);
        if heaptr < 2
          disp([' retrieveR - ERROR at type ' o ' level ' num2str(level)]);
          error(' retrieveR - bookkeeping error ')
        else
          [nH, mH] = size(H);
          if mH ~=1
            disp([' retrieveR - ERROR at type ' o ' level ' num2str(level)]);
            error(' retrieveR - heap should be column vector')
          else
            beginptr = heaptr-nF*mF;
            if heaptr-1 > nH
              disp([' retrieveR - ERROR at type ' o ' level ' num2str(level)]);
              error(' retrieveR - heap not that large')
            elseif beginptr < 1
              disp([' retrieveR - ERROR at type ' o ' level ' num2str(level)]);
              error(' retrieveR - heap not that large, dimensions?')
            else
              F = reshape(H(beginptr:(heaptr-1)), nF, mF);            
            end          
          end
        end             
      end            
    end
  end
end
%------------------------------------------------------------------------------

