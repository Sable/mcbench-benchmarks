function p = preal(v,dims)
%PREAL  Constructor of the preal class.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    p=double(v); % ... treat as double.
    return
end

baseDims=7;

switch nargin
    case 0
        p.value=NaN;
        p.units=zeros(1,baseDims);
        p=class(p,'preal');
    case 1
        if isempty(v)
            p.value=NaN;
            p.units=zeros(1,baseDims);
            p=class(p,'preal');
            return
        end
        if isa(v,'preal')
            p=v;
            return
        end
        if isnumeric(v)&imag(v)==0
            p=struct('value',cell(size(v)),'units',zeros(1,baseDims));
            for k=1:numel(v)
                p(k).value=v(k);
            end
            p=class(p,'preal');
        else
            error('Error in preal Constructor: Invalid value property')
        end
    case 2
        if isnumeric(v)&imag(v)==0
            p=struct('value',cell(size(v)),'units',zeros(1,baseDims));
            for k=1:numel(v)
                p(k).value=v(k);
            end
        else
            error('Error in preal Constructor: Invalid value property')
        end
        if isvector(dims)&length(dims)==baseDims&...
                isnumeric(dims)&imag(dims)==0
            for k=1:numel(v)
                p(k).units=dims;
            end
        else
            error('Error in preal constructor: Invalid units property')
        end
        p=class(p,'preal');
    otherwise
        error('Too many arguments to constructor')
end