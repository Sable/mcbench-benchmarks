% Called by Rcv_Pos_Compute to compute the Jacobian matrix.
function G = G_Compute(SV_Pos, Rcv_Pos)

[m, n] = size(SV_Pos);
dX = bsxfun(@minus, SV_Pos, Rcv_Pos);
Nor = sum(dX .^2, 2) .^0.5;
Unit_Mtrix = bsxfun(@rdivide, dX, Nor);
G = [-Unit_Mtrix ones(m,1)];

end