function [min] = yr2min(yr)
% Convert time from Julian years (365.25 days) to minutes. 
% Chad Greene 2012
min = yr*525960; % (Moments so dear.) 

% Clearly Jonathan Larson neglected leap year.