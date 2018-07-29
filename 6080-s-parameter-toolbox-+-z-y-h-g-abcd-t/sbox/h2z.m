function z = h2z(h);

% Z = h2z(H)
%
% Hybrid to Admittance transformation
% only for 2-by-2 matrices
%
% martie 27

if h(2,2) == 0
  disp('correspondent admittance matrix non-existent');
else
z(1,1) = h(1,1) - h(1,2)*h(2,1)/h(2,2);
z(1,2) = h(1,2)/h(2,2);
z(2,1) = -h(2,1)/h(2,2);
z(2,2) = 1/h(2,2);
end;