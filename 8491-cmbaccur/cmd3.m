function  fa = cmd3(a, om, omt)
% calculate the growth factor using 1/(ah)^3
% t0 is (1 - om)/om with om the relative matter density


%fa = (a ./ (1 + a .^3 * t0)) .^ 1.5;

fa = (a ./ (om + (omt - om) .* a.^3  + (1 - omt) .* a))  .^1.5;
