function h = subsasgn(h,index,value)
% Subsasgn for class hash

% Dimitar Atanasov, 2010
% datanasov@nbu.bg


% FIXME: for expressions H.key1.key1

if strcmp(index.type, '()')
    h = hash_put_value(h, cell2mat(index.subs), value);
else
    error('Cell array indexing is not dupported');
end;