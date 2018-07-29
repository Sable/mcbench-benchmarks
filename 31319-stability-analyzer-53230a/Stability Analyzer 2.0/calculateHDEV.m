function [oHDev] = calculateHDEV(tau,sPeriod,readings)
%Overlapping Hadamard (ADEV) function that uses phase error or time error values
%input argument is readings already grouped as tau values. tau is the
%desired gate or tau time needed for calculating overlap. 
%sPeriod is used to determine the overlap

N = numel(readings); %get the reading count
n = tau / sPeriod; %calculate averaging factor
n = floor(n); %make sure this is an integer
const = 1/(6*(N - (3*n))*tau^2); %calculate the const mult 1/(2*(N - (2*n))*tau^2)
%sum from i=1 to N-(3*n) (Xi+3m - 3Xi+2m + 3Xi+m - Xi)^2
sum = 0; %variable to store summation calculation


%loop for performing summation
for i = 1:(N-(3*n))
   sum = sum + (readings(i+(3*n)) - (3*readings(i+(2*n))) + (3*readings(i+n)) - readings(i))^2; 
end

oHDev = sqrt(const*sum); %square root for Allan Dev