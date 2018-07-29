function numdiff = ndiff(A)
%
% Accounts for the number of different elements that compose the matrix A

B = A(1);
for i=2:numel(A)
    if isempty(find(A(i) == B))
        B = [B A(i)];
    end
end
numdiff = length(B);
