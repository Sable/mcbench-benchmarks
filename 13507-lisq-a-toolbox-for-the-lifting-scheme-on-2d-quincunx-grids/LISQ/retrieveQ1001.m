function [F10, F01] = retrieveQ1001(level, o, H, L)
%------------------------------------------------------------------------------
%
% This function extracts gridfunction F10 and F01 from H.
% F10 is of colour '10' and F01 is of colour '01' such that together they
% constitute a quincunx gridfunction.
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
% F10 & F01 are supposed to be uniquely determined by the integer L (level)
% and character o describing its type.
% Function retrieveQ1001 is the counterpart of storeQ1001.
% This function is a two-dimensional lifting scheme utility.
%
% F10 = 2D gridfunction of coefficients of colour '10' extracted from H.
%
% F01 = 2D gridfunction of coefficients of colour '01' extracted from H.
%
% level = integer designated as the level of both F10 and F01.
%
% o = character, should be either 'a' or 'd',
%     describing the type of both F10 and F01:
%     'a' relates to approximation (coefficients) and
%     'd' relates to detail (coefficients)
%
% L = 2D integer array of bookkeeping, see function storeR.
%
% H = 1D array that functions as storage (heap). The coefficients of both F10
%     and F01 are extracted from H as a result of calling retrieveQ1001.
%
% See also: retrieveQ1001, retrieveQ, retrieveQ0110.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: October 17, 2002.
% (c) 1999-2002 Stichting CWI, Amsterdam.
%------------------------------------------------------------------------------
F10 = retrieveQ(level, '10', o, H, L);
F01 = retrieveQ(level, '01', o, H, L);
if isempty(F10) || isempty(F01)
  disp([' retrieveQ1001 - ERROR at type ' o ' with level ' num2str(level)]);
  error(' retrieveQ1001 - empty result ')
else
  [n10, m10]=size(F10);
  [n01, m01]=size(F01);
  if m01 > m10
    disp([' retrieveQ1001 - ERROR at type ' o ' with level ' num2str(level)]);
    error(' retrieveQ1001 - dimensions do not match for m01 > m10 ')
  end 
  if n10 > n01
    disp([' retrieveQ1001 - ERROR at type ' o ' with level ' num2str(level)]);
    error(' retrieveQ1001 - dimensions do not match for n10 > n01 ')
  end 
  if m10 > m01+1
    disp([' retrieveQ1001 - ERROR at type ' o ' with level ' num2str(level)]);
    error(' retrieveQ1001 - dimensions do not match for m10 > m01+1 ')
  end 
  if n01 > n10+1
    disp([' retrieveQ1001 - ERROR at type ' o ' with level ' num2str(level)]);
    error(' retrieveQ1001 - dimensions do not match for n01 > n10+1 ')
  end 
%
% m01 <= m10 <= m01+1 is satisfied
% n10 <= n01 <= n10+1 is satisfied
%
end
%------------------------------------------------------------------------------
