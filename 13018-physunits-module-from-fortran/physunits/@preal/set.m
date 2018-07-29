function p = set(p,varargin)
%PREAL/SET  The preal class SET method.

baseDims=7;

propertyArgIn=varargin;
while length(propertyArgIn)>=2,
    prop=propertyArgIn{1};
    val=propertyArgIn{2};
    propertyArgIn=propertyArgIn(3:end);
    switch prop
    case 'value'
        if isscalar(val)
            val=val*ones(size(p));
        end
        if ndims(val)~=ndims(p)
            error('Array dimensions must agree')
        end
        l=size(val)~=size(p);
        if any(l(:))
            error('Array dimensions must agree')
        end
        if isnumeric(val) & imag(val)==0
            for k=1:numel(val)
                p(k).value=val(k);
            end
        else
            error('Not a valid preal value')
        end
    case 'units'
        if isvector(val)&length(val)==baseDims&...
                isnumeric(val)&imag(val)==0
            for k=1:numel(p)
                p(k).units=val;
            end
        else
            error('Not valid preal units')
        end
    otherwise
        error('preal properties: value, units')
    end
end