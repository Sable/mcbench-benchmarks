function s = z2s4(z);

% S = z2s4(Z)
%
% Impedance to Scattering transformation
% only for N-by-4 matrix

size(z, 1)
for i = 1:size(z,1)
  d(i) = (1 + z(i, 1)).*(1 + z(i, 4)) - z(i,2).* z(i, 3)
  while abs(d(i)) < 1e-10
    fckindex = 1+round(rand*3);
    z(i, fckindex) = z(i, fckindex)*(1+rand*1e-10);
    d(i) = (1 + z(i, 1)).*(1 + z(i, 4)) - z(i,2).* z(i, 3);
  end;
end;

d = rot90(d, 3);

% at this point the 1+Z matrix should be non-singular

s(:, 1) = ((z(:, 1) - 1) .* (z(:, 4) + 1) - z(:,2).* z(:, 3))./d;
s(:, 2) = 2* z(:,2)./d;
s(:, 3) = 2* z(:,3)./d; 
s(:, 4) = ((z(:, 1) + 1) .* (z(:, 4) - 1) - z(:,2).* z(:, 3))./d;