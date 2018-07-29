function z = g2z(g);

% Z = g2z(G)
%
% Hybrid G to Impedance transformation
% only for 2-by-2 matrices
%
% martie 27

if g(1,1) == 0
  disp('correspondent admittance matrix non-existent');
else
z(1,1) = 1/g(1,1);
z(1,2) = -g(1,2)/g(1,1);
z(2,1) = g(2,1)/g(1,1);
z(2,2) = g(2,2) - g(1,2)*g(2,1)/g(1,1);
end;