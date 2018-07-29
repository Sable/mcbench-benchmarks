function [kJ] = cal2kJ(cal)
% Convert energy or work from calories to kilojoules.
% Note: these calories are different from the capitalized Calories found on
% American cereal boxes.  American consumers are to healthy to eat a
% 250,000 calorie candy bar.  
% Chad A. Greene 2012
kJ = cal*0.0041868;