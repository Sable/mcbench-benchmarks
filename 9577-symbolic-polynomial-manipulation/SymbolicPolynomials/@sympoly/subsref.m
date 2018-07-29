function r=subsref(p,S)
% sympoly/subsref: 
% usage: 
% 
% arguments:
%  p - sympoly object
%
%  S - reference structure
%
%  r - result

for i=1:length(S)
  switch S(i).type
   case '()'
    % create a structure array of sympolys
    r=p(S(i).subs{:});

  case '{}'
    % create a structure array of sympolys
    r=p{S(i).subs{:}};
    
   case '.'
    % return the appropriate field of p
    % sympoly fields are 'Coefficient', 'Var', 'Exponent'
    switch S(i).subs
     case 'Var'
      r=p.Var;
     case 'Exponent'
      r=p.Exponent;
     case 'Coefficient'
      r=p.Coefficient;
     otherwise
      error 'No field by that name in a sympoly object'
     end
  end
  if length(S)>1
    p=r;
  end
end



