function v=hash_get_value(hs,key,h)
% v=hash_get_value(hs,key,h)
%   Returns value of the hash hs for a given key
%   If key is not found and h = 1 than the 
%   result is an empty hash. If h = 2 - result is 0.
%
%   Input:
%       hs  - hash clas
%       key - key value
%       h   - type of returned value if key is not
%             found. 
%
%   Output: 
%       v   - value in hs for that key

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

id = sum(key);
if size(hs.idx,2) < id
    v = [];
else
    I = hs.idx(id);
    if I ~= 0
        Il = find( strcmp(hs.keys{I}, key) );
        if isempty(Il)
            v = [];
        else
            v = hs.values{I}(Il);
        end;
    else
        v = [];
    end
end;

if isempty(v)
    if nargin == 3
        if h == 1
            v = hash;
        elseif h == 2
            v = 0;
        else
            v = {};
        end;
    else
        v = {};
    end;
end;