function values=hash_values(hs)
% keys=hash_values(hs)
%   Returns cell array of values of the hash hs
%
%   Input:
%       hs  - hash clas
%
%   Output: 
%       values- cell array

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

K = hs.values;

values = [];

for k=1:size(K,2)
    for k1= 1:size(K{k},2)
        if isa(K{k}(k1),'hash')
            continue;
        end;    
        values = [values K{k}(k1)];
    end;
end;