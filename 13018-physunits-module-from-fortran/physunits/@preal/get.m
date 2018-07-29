function val = get(p,prop_name)
%PREAL/GET  The preal class GET method.

switch prop_name
    case 'value'
        val=ones(size(p));
        for k=1:numel(p)
            val(k)=p(k).value;
        end
    case 'units'
        if isscalar(p)
            val=p.units;
        else
            val=cell(size(p));
            for k=1:numel(p)
                val{k}=p(k).units;
            end
        end
    otherwise
        error([prop_name,' is not a valid preal property'])
end