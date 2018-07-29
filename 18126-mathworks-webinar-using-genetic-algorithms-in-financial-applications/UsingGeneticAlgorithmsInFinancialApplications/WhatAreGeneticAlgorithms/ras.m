function scores = ras(pop)
% shortcut to rastriginsfcn()

scores = 10.0 * size(pop,2) + sum(pop .^2 - 10.0 * cos(2 * pi .* pop),2);



