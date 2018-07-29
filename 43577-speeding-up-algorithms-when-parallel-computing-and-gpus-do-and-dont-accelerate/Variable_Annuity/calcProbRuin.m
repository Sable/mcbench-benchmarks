function probRuin = calcProbRuin(EquitySAVal)
% A helper function that calculates the probability of ruin given the
% account values.

probRuin = sum(min(EquitySAVal) == 0) / size(EquitySAVal, 2);
end