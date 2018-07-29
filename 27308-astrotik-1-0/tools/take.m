% ASTROTIK by Francesco Santilli
%
% Usage = [x1,x2,...] = take(x)
%
% where: x = [x1 x2 ...]

function varargout = take(x)

    if nargin ~= 1
        error('Wrong number of input arguments.')
    end 
    
    if ndims(x) ~= 2
        error('Wrong size of input arguments.')
    end
    
    K = nargout;
    if K > size(x,2)
        error('Wrong size of input arguments.')
    end
    
    y = cell(K);
    for k = 1:K
        y(k) = {x(:,k)};
    end
    varargout = y;

end