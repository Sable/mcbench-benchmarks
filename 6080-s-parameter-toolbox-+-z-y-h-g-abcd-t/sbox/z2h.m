function h = z2h(z);

% H = z2h(Z)
%
% Admittance to Hybrid transformation
% only for 2-by-2 matrices
%
% martie 27

if z(2,2) == 0
  disp('correspondent admittance matrix non-existent');
else
h(1,1) = z(1,1) - z(1,2)*z(2,1)/z(2,2);
h(1,2) = z(1,2)/z(2,2);
h(2,1) = -z(2,1)/z(2,2);
h(2,2) = 1/z(2,2);
end;