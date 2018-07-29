function A=matrix_normalizer(B)

[m n] = size(B);

for i = 1:n
    A(:,i) = B(:,i)/norm(B(:,i));
end