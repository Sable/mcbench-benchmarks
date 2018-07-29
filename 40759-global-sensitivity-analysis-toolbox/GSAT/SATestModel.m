function [D Si] = SATestModel(p)

Bi = 1./(3*((1+p).^2));

D = prod((1+Bi))-1;

L = 2^length(p);

Si = nan(1,L-1);

for i=1:(L-1)
    ii = fnc_GetInputs(i);
    Si(i) = prod(Bi(ii))/D;
end