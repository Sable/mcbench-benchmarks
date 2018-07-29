function  v=subsref(h, index)
% Subsref for class hash

% Dimitar Atanasov, 2010
% datanasov@nbu.bg


if strcmp(index.type, '()')
    v = hash_get_value(h, index.subs{1});
elseif strcmp(index.type, '{}')
    error('Cell array indexing is not dupported');
elseif strcmp(index.type, '.')
    if strcmp(index.subs, 'keys')
        v = hash_keys(h);
    elseif strcmp(index.subs, 'values')
        v = hash_values(h);
    elseif strcmp(index.subs, 'idx')
        v = h.idx;
    else 
        error('Unsupported propertie of the hash');
    end;
end;