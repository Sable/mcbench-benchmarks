function  result = simpsint(ct0, ct1, table)
% simpsint.m integrates a table from ct0 to ct1 with the Simpson rule, see W Press Numerical recipes(1994) p134.
% The integration is done columns wise, the result is a row which matches the number of columns in the table.
% It is assumed that the integration has a constant interval (step2).
%
% D Vangheluwe 27 dec 2004

[nt2 nk] = size(table);
a0 = 1/3;
a4 = 4/3;
a2 = 2/3;
 
step2 = (ct1 - ct0)/(nt2 - 1);

% the result has size 1 x nk
if mod(nt2, 2) >0  %odd nt2
  result = step2 *( a0*(table(1,:) + table(nt2,:)) + a4*sum(table(2:2:nt2-1,:)) + a2*sum(table(3:2:nt2-2,:)) );
else  % even nt2
  result = step2 *( a0*(table(1,:) + table(nt2,:)) + ...
     a4*sum(table(2:2:nt2-4,:)) + a2*sum(table(3:2:nt2-3,:)) + a2*table(nt2-2,:) + a4*table(nt2-1,:) );
end
