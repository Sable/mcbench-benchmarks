function [eV] = kcal2eV(kcal)
% Convert energy or work from kilocalories to electron volts.
% Note: kilocalories are the same thing as nutritional Calories. 
% Chad A. Greene 2012
eV = kcal*2.613193933e+22;