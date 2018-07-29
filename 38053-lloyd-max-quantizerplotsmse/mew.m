function [ mu ] = mew( min,max )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
ts=0.01;
intn = 0;
intd = 0;
for i=min:ts:max
    intn = intn+ts*i*exp(-i*i);
    intd = intd+ts*exp(-i*i);
end
mu = intn/intd;
end

