function status = strwcmp(string1, string2, casesense)
%STRWCMP compares two strings allowing wildcards.
%  
%  S = STRWCMP(STR1, STR2) returns TRUE if the two strings STR1 and 
%  STR2 match. One of the strings may contain one or more '*' as 
%  wildcard characters. The comparison is case sensitive. If the
%  strings are matrices they are treated as vectors.
%
%  S = STRWCMP(STR1, STR2, 'I') ignores the case.

%  Uses: Matlab5.0
%
%  Peter M. W. Nave, 100010.3276@CompuServe.com
%  1998-04-01.
%----------------------------------------------------------------------O
  status = 1;
  string1 = string1(:)'; string2 = string2(:)';
  if ~isa(string1, 'char') | ~isa(string2, 'char')
     error('### strwcmp: both input arguments must be character arrays')
  end
  if any(string1 == '*')
     mask = string1;
     if any(string2 == '*')
        error('### strwcmp: only one input string may contain ''*''.')
     end
     string = string2;
  else
     string = string1;
     mask = string2;
  end
  if nargin > 2
     if strncmp(lower(casesense), 'i', 1)
        string = lower(string); mask = lower(mask);
     end
  end
  
  first = ~strncmp(mask, '*', 1);

  for ii = 1:inf
     if isempty(mask)
        return
     end
     if all(mask == '*')
        return
     end
  
     [token, mask] = strtok(mask, '*');
     
     ind = findstr(string, token);
     if isempty(ind)
        status = 0;
        return
     else
        if first
           if ind(1) == 1
              string = string(length(token) + 1:end);
           else
              status = 0;
              return
           end
           first = 0;
        else
           string = string(ind(1) + length(token):end);
           if ~length(string)
              return
           end
        end
     end
  end
%
% End of strwcmp.
  
