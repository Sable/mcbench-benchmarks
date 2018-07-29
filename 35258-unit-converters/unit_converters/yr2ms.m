function [ms] = yr2ms(yr)
% Convert time from Julian years (365.25 days) to milliseconds. 
% Chad Greene 2012
ms = yr*31557600000;