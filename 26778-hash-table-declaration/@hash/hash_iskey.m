function k=hash_iskey(hs,key)
% k=hash_iskey(hs,key)
%   Returns 1 if key exist in hash hs, 0 otherwise
%
%   Input:
%       hs  - hash clas
%       key - key value
%
%   Output: 
%       k   - 0 or 1

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

id = sum(key);
if size(hs.idx,2) < id
    k = 0;
else
    I = hs.idx(id);
    Il = find( strcmp(hs.keys{I}, key) );
    k = ~isempty(Il)
end;
    
