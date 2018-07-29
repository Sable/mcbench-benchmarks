% FRACTIONS normalise ternary data
%   [fA, fB, fC] = FRACTIONS(A, B, C) calculates fractional values for 

function [fA, fB, fC] = fractions(A, B, C)
Total = (A+B+C);
fA = A./Total;
fB = B./Total;
fC = 1-(fA+fB);
