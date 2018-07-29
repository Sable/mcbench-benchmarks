function [kcal] = cal2kcal(cal)
% Convert energy or work from calories to kilocalories.
% Note: these calories are different from the capitalized Calories found on
% American cereal boxes.  I suppose we'd be afraid to eat a candy bar with
% 250,000 calories in it.  Because then we'd feel like fatties. 
% Chad A. Greene 2012
kcal = cal/1000;