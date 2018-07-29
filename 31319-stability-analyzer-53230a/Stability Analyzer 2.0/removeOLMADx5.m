function madReadings = removeOLMADx5(readings)
%This function removes outliers from the data set using the median
%absolute deviation method with a x5 factor. The formula used is 
%MAD = Median { | y(i) - m | / 0.6745 }

med = median(readings); %get median value of readings
x = abs((readings - med)); %get absolute value of each reading minus median value
MADx5 = median(x/.6745)*5; %get value of x array and multiply it by 5, result is outlier factor
j = 1; %variable for non-outlier array
madReadings = zeros(1,length(readings));%allocate array for storing readings with outliers removed

for i = 1:length(readings) %this loop removes outliears
    if readings(i) <= (med + MADx5) && readings(i) >= (med - MADx5)
        madReadings(j) = readings(i);%if not an outlier add to array
        j = j + 1;
    end

end

madReadings((j):length(madReadings)) = [];%delete empty array items
