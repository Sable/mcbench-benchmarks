function g = z2g(z);

% G = z2g(Z)
%
% Impedance to Hybrid G transformation
% only for 2-by-2 matrices
%
% martie 27

if z(1,1) == 0
  disp('correspondent admittance matrix non-existent');
else
g(1,1) = 1/z(1,1);
g(1,2) = -z(1,2)/z(1,1);
g(2,1) = z(2,1)/z(1,1);
g(2,2) = z(2,2) - z(1,2)*z(2,1)/z(1,1);
end;