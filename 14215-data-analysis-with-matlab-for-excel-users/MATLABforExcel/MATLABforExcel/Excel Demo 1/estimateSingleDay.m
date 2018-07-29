function estimateSingleDay(energyData, DayType, dayOfWeek, timeOfDay)

% estimateSingleDay(energyData, DayType, dayOfWeek, timeOfDay)
%   Estimates energy usage for a particular day and time based on
%   historical data.
%
%   Inputs:
%     energyData - historical energy usage data
%     DayType    - information on the day of the week
%     dayOfWeek  - the day of interest
%     timeOfDay  - the hour(s) of interest

% Copyright 2006-2009 The MathWorks, Inc.

allDays   = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', ...
  'Friday', 'Saturday', 'Sunday'};

singleDay = energyData(DayType == strmatch(dayOfWeek, allDays), :);
[singleDayMean, singleDayStDev, singleDayCI] = normfit(singleDay);
sysLoad   = singleDayMean(timeOfDay)
sysLoadCI = singleDayCI(:, timeOfDay)

% Visualize
figure;
plot(singleDay');hold on;
plot(singleDayMean, 'linewidth', 4);
plot([timeOfDay;timeOfDay], sysLoadCI, 'r', 'linewidth', 2)
plot(timeOfDay, sysLoad, 'r.', 'markersize', 30);
xlabel('hours');
ylabel('system load (MW)');
title(sprintf('Estimate for %ss & 95%% CI', dayOfWeek));
hold off;
