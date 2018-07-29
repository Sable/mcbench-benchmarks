function [fracFreqArray] = calculateFracFreq(ref,readings)
%caculates the fractional frequency error of an array of frequency readings
fracFreqArray = readings - ref;
fracFreqArray = fracFreqArray / ref;