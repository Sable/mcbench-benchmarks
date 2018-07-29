function sump=sum(p,dim)
% sympoly/sum: sum a sympoly array along a given dimension
% usage: sump=sum(p);
% usage: sump=sum(p,dim);
% 
% arguments:
%    p - sympoly array object
%  dim - (OPTIONAL) dimension to sum over
%        DEFAULT ==1, unless sp is a row vector
%
%  sump - sympoly object containing the sum reduced array

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

% for dim == 1 or dim == 2, do the sum using a dot product
if (dim == 1) && (np == 2)
  % sum down rows
  sump = ones(1,s(1))*p;
  
elseif (dim == 2) && (np == 2)
  % sum across columns
  sump = p*ones(s(2),1);

else
  % its an n-d array
  ss = s;
  ss(dim) = 1;
  
  si = cell(1,np);
  for i = 1:np
    si{i} = 1:s(i);
  end
  
  if any(ss~=1)
    sump = repmat(sympoly(0),ss);
  else
    sump = sympoly(0);
  end
  for i = 1:s(dim)
    si{dim} = i;
    sump = sump + p(si{:});
  end

end



