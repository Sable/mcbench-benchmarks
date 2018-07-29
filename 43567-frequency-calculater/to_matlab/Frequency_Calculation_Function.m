function [f,f_time] = Frequency_Calculation_Function(Singal,time)
% This function will locate the zero crossing in your input signal and
% calculate the frequency of that input signal.
% Author: Aubai Al Khatib datum: 19.09.2013 
Zeros = Zeros_finding(Singal,time);
f = 1./(2*diff(Zeros));
f_time = Zeros(1:length(f));
end
