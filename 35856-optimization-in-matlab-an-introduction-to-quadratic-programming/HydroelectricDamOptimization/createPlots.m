function createPlots(turbFlow,spillFlow,inFlow,price,s0,C2A,n)
% Copyright (c) 2012, MathWorks, Inc.
%% Calculations for Plots

totStor = zeros(n+1,1);  % Total storage in the reservoir
totStor(1) = s0;  % Initial Storage
% Use the time history data to compute the reservoir storage at each step
for ii = 2:length(inFlow)+1
    totStor(ii) = totStor(ii-1) + ...
        (inFlow(ii-1)-turbFlow(ii-1)-spillFlow(ii-1))*C2A;
end

% Days data for plotting
days = (0:n-1)/24;

%% Calculate revenue for this solution

% Optimal strategy
totValue = calculateValue(s0,price,inFlow,turbFlow,spillFlow,C2A,n);
totValue = cumsum(totValue);

% Old strategy
totValue2 = calculateValue(s0,price,inFlow,inFlow,spillFlow,C2A,n);
totValue2 = cumsum(totValue2);

%% Make Plot
figure('Position',[100 100 900 600]);

subplot(2,2,1);
plot(days,price,'-','LineWidth',2,'Color',[0 0.7 0])
title('Electricity Price'); ylabel('Price ($/MWh)'); xlabel('Time (days)')
grid on

subplot(2,2,2);
plot(days,totValue/1E6,'-','LineWidth',2)
hold on
plot(days,totValue2/1E6,'-r','LineWidth',2)
title('Total Value of Electricity Produced'); ylabel('Value (millions of $)') 
xlabel('Time (days)')
grid on
legend('Optimal Turbine Flow','Turbine Flow = Inlet Flow',...
    'Location','northwest')


subplot(2,2,3);
plot(days,turbFlow,'-xb'); hold on; plot(days,spillFlow,'-xr')
title('Optimal Flow'); ylabel('Flow (CFS)'); xlabel('Time (days)')
grid on
leg = legend('Turbine Flow','Spill Flow');
set(leg,'Location','NorthWest');

subplot(2,2,4);
plot([days n/24],totStor,'-b','LineWidth',2)
title('Total Storage in Reservoir'); ylabel('Total Storage (AF)')
xlabel('Time (days)')
grid on


