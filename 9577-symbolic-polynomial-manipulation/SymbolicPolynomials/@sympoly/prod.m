function prodp=prod(p,dim)
% sympoly/prod: product of a sympoly array along a given dimension
% usage: prodp=prod(p);
% usage: prodp=prod(p,dim);
% 
% arguments:
%    p - sympoly array object
%  dim - (OPTIONAL) dimension to product over
%        DEFAULT ==1, unless sp is a row vector
%
%  prodp - sympoly object containing the product reduced array

s = size(p);
np = length(s);

% default for dim is 1, UNLESS p is a row vector.
if (nargin<2) || isempty(dim)
  if (s(1) == 1) && (np==2)
    % a row vector
    dim = 2;
  else
    % any other shape array
    dim = 1;
  end
end

ss = s;
ss(dim) = 1;

si = cell(1,np);
for i = 1:np
  si{i} = 1:s(i);
end

if any(ss~=1)
  prodp = repmat(sympoly(1),ss);
else
  prodp = sympoly(1);
end
for i = 1:s(dim)
  si{dim} = i;
  prodp = prodp .* p(si{:});
end




