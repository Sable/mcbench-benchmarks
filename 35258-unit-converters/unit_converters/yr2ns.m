function [ns] = yr2ns(yr)
% Convert time from Julian years (365.25 days) to nanoseconds. 
% If you ever actually use this, let me know.  I'd be interested to know
% who needs this conversion and why.  
% Chad Greene 2012
ns = yr*31557600000000000;