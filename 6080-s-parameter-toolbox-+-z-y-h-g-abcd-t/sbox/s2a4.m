function a = s2a4(S);

% ABCD = s2a4(S)
%
% Scattering to ABCD transformation
% only for N-by-4 matrix

for i = 1:size(S,1)
  d(i) = 2 * S(i, 3);
  while abs(d(i)) < 1e-8
    fckindex = 1+round(rand*3);
    S(i, 3) = S(i, 3)*(1+rand*1e-8);
    d(i) = 2* S(i, 3);
  end;
end;

d = rot90(d, 3);

a(:, 1) = ((1 + S(:, 1)).*(1 - S(:, 4)) + S(:,2).* S(:, 3))./d;
a(:, 2) = ((1 + S(:, 1)).*(1 + S(:, 4)) - S(:,2).* S(:, 3))./d;
a(:, 3) = ((1 - S(:, 1)).*(1 - S(:, 4)) - S(:,2).* S(:, 3))./d; 
a(:, 4) = ((1 - S(:, 1)).*(1 + S(:, 4)) + S(:,2).* S(:, 3))./d;