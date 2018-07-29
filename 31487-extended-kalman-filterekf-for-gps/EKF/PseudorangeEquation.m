% Compute Val = || Xs - X || + b and its Jacobian.
function [Val, Jacob] = PseudorangeEquation(X, SV)

% Each row of SV is the coordinate of a satellite.
dX = bsxfun(@minus, X([1,3,5])', SV);% X - Xs
Val = sum(dX .^2, 2) .^0.5 + X(7);
Jacob = zeros(size(SV, 1), size(X, 1));
Jacob(:, [1,3,5]) = bsxfun(@rdivide, dX, Val);
Jacob(:, 7) = 1;

end