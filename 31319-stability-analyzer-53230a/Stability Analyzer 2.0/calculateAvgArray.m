function [avgArray] = calculateAvgArray(tau, sPeriod, readings)
%This function uses raw readings and returns an array of readings for the
%input Tau argument. readings can either be freq or time

avgCount = tau / sPeriod; %gets count for averaging
loopCount = numel(readings) / avgCount; %get number of loop iterations needed
loopCount = floor(loopCount); %convert loopCount to integer in case it is a non int

avgArray = zeros(1,loopCount); %allocate array
iter = 0;
iter = int32(iter);

%loop to build array
for i = 1:loopCount
    temp = mean(readings((iter+1):(iter+avgCount)));
    avgArray(i) = temp;
    iter = iter + avgCount;
end

