function h=hash_remove(hs,key)
% h=hash_remove(hs,key)
%   Removes data for a given key
%
%   Input:
%       hs    - hash clas
%       key   - key value
%
%   Output: 
%       h     - a result hash

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

if ~isstr(key) 
    error('Hash key should be string');
end;

if hash_iskey(key)
    id = sum(key);
    I = hs.idx(id);
    Il = find( strcmp(hs.keys{I}, key) );
    hs.keys{I} = [hs.keys{I}{Il-1} hs.keys{I}{Il+1}];
    hs.values{I} = [hs.values{I}{Il-1} hs.values{I}{Il+1}];
end;
h = hs;