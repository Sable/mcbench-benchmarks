function h=hash_put_value(hs,key,value)
% h=hash_put_value(hs,key,value)
%   Puts value with a given key in the hash hs
%
%   Input:
%       hs    - hash clas
%       key   - key value
%       value - value
%
%   Output: 
%       h     - a result hash

% Dimitar Atanasov, 2010
% datanasov@nbu.bg



id = sum(key);
if size(hs.idx,2) < id
    hs.idx(id + 1) = 0;
end;

I = hs.idx(id);

if I == 0
    hs.values{end+1} = value;
    hs.keys{end+1} = {key};
    hs.idx(id) = size(hs.keys,2);
else
    Il = find( strcmp(hs.keys{I}, key) );
    if isempty(Il)
        hs.keys{I} = [ hs.keys{I} key ];
        hs.values{I} = [ hs.values{I} value];
    else
        hs.values{I}(Il) = value;
    end;
end;

h = hs;