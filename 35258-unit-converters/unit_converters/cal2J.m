function [J] = cal2J(cal)
% Convert energy or work from calories to joules.
% Note: these calories are different from the capitalized Calories found on
% American cereal boxes.  American consumers are to healthy to eat a
% 250,000 calorie candy bar.  
% Chad A. Greene 2012
J = cal*4.1868;