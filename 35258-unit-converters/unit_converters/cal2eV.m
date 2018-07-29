function [eV] = cal2eV(cal)
% Convert energy or work from calories to electron volts.
% Note: these calories are different from the capitalized Calories found on
% American cereal boxes.  American consumers are to healthy to eat a
% 250,000 calorie candy bar.  
% Chad A. Greene 2012
eV = cal*26131939330000000000;