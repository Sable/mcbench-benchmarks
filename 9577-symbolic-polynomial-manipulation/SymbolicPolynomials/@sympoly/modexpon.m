function S = modexpon(S,p)
% Reduces the exponents of a sympoly modulo p
% Usage: S = modexpon(S,p)
%
% S is any sympoly
% p a scalar numeric value
%

if numel(S) > 1
  for i = 1:numel(S)
    S(i) = modexpon(S(i),p);
  end
else
  % a scalar sympoly
  S.Exponent = mod(S.Exponent,p);
  
  S = clean_sympoly(S);
end




