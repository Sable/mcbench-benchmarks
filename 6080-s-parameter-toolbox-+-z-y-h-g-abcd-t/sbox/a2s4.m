function s = a2s4(A);

% S = a2s4(ABCD)
%
% ABCD to Scattering transformation
% only for N-by-4 matrix

for i = 1:size(A,1)
  d(i) = A(i, 1) + A(i, 2) + A(i, 3) + A(i, 4);
  while abs(d(i)) < 1e-8
    fckindex = 1+round(rand*3);
    A(i, fckindex) = A(i, fckindex)*(1+rand*1e-8);
    d(i) = A(i, 1) + A(i, 2) + A(i, 3) + A(i, 4);
  end;
end;

d = rot90(d, 3);

s(:, 1) = (A(:, 1) + A(:, 2) - A(:, 3) - A(:, 4))./d;
s(:, 2) = 2*(A(:, 1).*A(:, 4) - A(:, 2).*A(:, 3))./d;
s(:, 3) = 2./d;
s(:, 4) = (- A(:, 1) + A(:, 2) - A(:, 3) + A(:, 4))./d;
