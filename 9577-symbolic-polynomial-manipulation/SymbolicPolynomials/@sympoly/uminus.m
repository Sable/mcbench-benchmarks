function sp=uminus(sp)
% sympoly/uminus: Negates a sympoly object
% usage: sp = -sp;
% 
% arguments:
%  sp - a sympoly object

% Is it a scalar objects or an array?
s1 = numel(sp);

if (s1>1)
  % s1 is an array or vector sympoly
  for i = 1:s1
    sp(i) = -sp(i);
  end
  
else
  % must be a scalar sympoly
  sp.Coefficient= - sp.Coefficient;
  
end

