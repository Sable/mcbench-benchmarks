% Plots the motor data
% Copyright 2006-2009 The MathWorks, Inc.
figure('windowstyle', 'docked')
plot(rpm,bench,'.-b','MarkerSize',15);hold on
line(rpm,expmodel,'color','g','LineWidth',2);
plot(rpm,lowerbound,':r'); plot(rpm,upperbound,':r');
legend('Benchmark motor data','Exponential fit',...
    '95% confidence bounds','location','se')
