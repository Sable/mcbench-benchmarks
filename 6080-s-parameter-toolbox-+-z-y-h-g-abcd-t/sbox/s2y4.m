function y = s2y4(S);

% Y = s2y4(S)
%
% Scattering to Admittance transformation
% only for N-by-4 matrices

for i = 1:size(S,1)
  d(i) = (1 + S(i, 1)).*(1 + S(i, 4)) - S(i,2).* S(i, 3);
  while abs(d(i)) < 1e-7
    fckindex = 1+round(rand*3);
    S(i, fckindex) = S(i, fckindex)*(1+rand*1e-8);
    d(i) = (1 + S(i, 1)).*(1 + S(i, 4)) - S(i,2).* S(i, 3);
  end;
end;

d = rot90(d, 3);

y(:, 1) = ((1 - S(:, 1)).*(1 + S(:, 4)) + S(:,2).* S(:, 3))./d;
y(:, 2) = -2 * S(:,2)./d;
y(:, 3) = -2 * S(:,3)./d; 
y(:, 4) = ((1 + S(:, 1)).*(1 - S(:, 4)) + S(:,2).* S(:, 3))./d;