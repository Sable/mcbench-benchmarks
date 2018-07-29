function [oAllanDev] = calculateADEV(tau,sPeriod,readings)
%Overlapping Allan (ADEV) function that uses phase error or time error values
%input argument is readings already grouped as tau values. tau is the
%desired gate or tau time needed for calculating overlap. 
%sPeriod is used to determine the overlap

N = numel(readings); %get the reading count
n = tau / sPeriod; %calculate averaging factor
n = floor(n); %make sure this is an integer
const = 1/(2*(N - (2*n))*tau^2); %calculate the const mult 1/(2*(N - (2*n))*tau^2)
%sum from i=1 to N-2n (Xi+2m - 2Xi+m + Xi)^2
sum = 0; %variable to store summation calculation


%loop for performing summation
for i = 1:(N-(2*n))
   sum = sum + (readings(i+(2*n)) - (2*readings(i+n)) + readings(i))^2; %previos sum + (yi+1 - yi)^2
end

oAllanDev = sqrt(const*sum); %square root for Allan Dev