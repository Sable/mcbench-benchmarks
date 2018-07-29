function [us] = yr2us(yr)
% Convert time from Julian years (365.25 days) to microseconds. 
% Chad Greene 2012
us = yr*31557600000000;