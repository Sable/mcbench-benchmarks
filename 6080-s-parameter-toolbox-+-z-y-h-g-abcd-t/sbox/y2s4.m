function s = y2s4(y);

% S = y2s4(Y)
%
% Admittance to Scattering transformation
% only for N-by-4 matrix

for i = 1:size(y,1)
  d(i) = (1 + y(i, 1)).*(1 + y(i, 4)) - y(i,2).* y(i, 3);
  while abs(d(i)) < 1e-10
    fckindex = 1+round(rand*3);
    y(i, fckindex) = y(i, fckindex)*(1+rand*1e-11);
    d(i) = (1 + y(i, 1)).*(1 + y(i, 4)) - y(i,2).* y(i, 3);
  end;
end;

d = rot90(d, 3);

s(:, 1) = ((1 - y(:, 1)) .* (1 + y(:, 4)) + y(:,2).* y(:, 3))./d;
s(:, 2) = -2* y(:,2)./d;
s(:, 3) = -2* y(:,3)./d; 
s(:, 4) = ((1 + y(:, 1)) .* (1 - y(:, 4)) + y(:,2).* y(:, 3))./d;