% ASTROTIK by Francesco Santilli

function varargout = check(x,n)

    if ~isa(x,'double')
        error('Wrong class of an input argument.')
    end
    
    if ~isreal(x)
        error('Input arguments must be real.')
    end
    
    for k = 1:length(n)
        if n(k)==0
            s(k) = isscalar(x);
        elseif n(k)==1
            s(k) = isvector(x);
        elseif n(k)>1
            s(k) = (ndims(x)==n(k));
        end
    end
    
    if ~any(s)
        error('Wrong size of an input argument.')
    end
    
    if nargout == 1
        varargout(1) = {length(x)};
    elseif nargout > 1
        for k = 1:nargout
            varargout(k) = {size(x,k)};
        end
    end
    
end