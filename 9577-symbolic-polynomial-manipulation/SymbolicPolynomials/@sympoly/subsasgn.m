function r=subsasgn(p,S,B)
% sympoly/subsasgn:
% usage:
% 
% arguments:
%  p - sympoly object
%
%  S - reference structure
%
%  r - returned sympoly

r=sympoly(p);
switch S(1).type
 case '()'
  % subscripted assignment can build sympoly arrays
  r(S(1).subs{:})=B;
  
 case '.'
  % replace the appropriate field of p
  % sympoly fields are 'coef' and 'varname'
  fn = lower(S(1).subs);
  switch fn
   case 'var'
    r.Var=B;
   case 'exponent'
    r.Exponent=B;
   case 'coefficient'
    r.Coefficient=B;
   otherwise
    error 'No field by that name in a sympoly object'
   end
end




