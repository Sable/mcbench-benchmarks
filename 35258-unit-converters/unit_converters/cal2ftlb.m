function [ftlb] = cal2ftlb(cal)
% Convert energy or work from calories to foot-pounds.
% Note: these calories are different from the capitalized Calories found on
% American cereal boxes.  American consumers are to healthy to eat a
% 250,000 calorie candy bar.  
% Chad A. Greene 2012
ftlb = cal*3.0880253167;