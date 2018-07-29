function ta=normalize(x)
% NORMALIZE - return vector with unit length

if ~(nargin==1)
    error('Input should be just one vector')
end



ta=x/norm(x);


