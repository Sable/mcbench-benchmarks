function [erg] = cal2erg(cal)
% Convert energy or work from calories to ergs.
% Note: these calories are different from the capitalized Calories found on
% American cereal boxes.  American consumers are to healthy to eat a
% 250,000 calorie candy bar.  
% Chad A. Greene 2012
erg = cal*41868000;