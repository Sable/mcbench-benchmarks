function plotResults(price,x,N)
% Copyright (c) 2012, MathWorks, Inc.
%% Create a new figure
figure;

%% Top plot of price data
subplot(2,1,1);
plot(price)
% Add labels
xlabel('Time (hrs)');
ylabel('Price ($/MWh)');
title('Electricity Prices');

%% Bottom plot is flow rates
subplot(2,1,2);
plot(x(1:N),'-*b');
hold on;
plot(x(N+1:end),'-*r');
% Add labels
xlabel('Flow (CFS)');
ylabel('Time (hrs)');
title('Spill and Turbine Flow Rates');
% Add legend in upper left (NorthWest) corner
legend('Turbine Flow','Spill Flow','Location','NorthWest');