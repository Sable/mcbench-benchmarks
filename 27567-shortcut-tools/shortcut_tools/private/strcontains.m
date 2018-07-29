function yn = strcontains(C1, C2)
%STRCONTAINS Does a cell array contain a particular string?
% 
% YN = STRCONTAINS(C1, C2).  C1 and C2 should be a cell array of strings
% and a single string, in either order.  If the single string is one of
% the strings in the cell array, the function returns true, otherwise
% false.
% 
% $Author: rcotton $  $Date: 2010/10/01 13:58:36 $	$Revision: 1.1 $
% $Copyright: Health and Safety Laboratory 2010 $

% Basic input checking
if (~iscellstr(C1) || ~ischar(C2)) && (~iscellstr(C2) || ~ischar(C1))
   warning('strcontains:BadInputs', ...
      'Inputs should be a cell array of strings and a single string');
   yn = false;
   return;
end

yn = any(strcmp(C1, C2));
end