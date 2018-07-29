function keys=hash_keys(hs)
% keys=hash_keys(hs)
%   Returns cell array of keys of the hash hs
%
%   Input:
%       hs  - hash clas
%
%   Output: 
%       keys- cell array

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

K = hs.keys;

keys = {};

for k=1:size(K,2)
    for k1 = K{k}
        keys = [keys k1];
    end;
end;