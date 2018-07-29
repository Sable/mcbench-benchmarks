%% RangeFrame Demo
%  
%  James Houghton
%  James.P.Houghton@gmail.com
%  December 4 2009
%
% Requires rangeframe.m
%
% In this demo we use the range frame to display the range of the first and last quartile, 
% and the mean of a bivariate scatter plot. The same range frame could display other information,
% such as median, standard deviation, etc. with appropriate explanation.
%

%% Generate data to plot
x = exp(0 + .5*randn(1,100));                 % the log-normal is an interesting distribution
y = x + .15*randn(1,100);

%% determine relevant range frame points
x_sort = sort(x);
x_Q1 = x_sort(round(length(x_sort)/4));       %approximate 1st quartile
x_Q3 = x_sort(round(length(x_sort)*3/4));     %approximate 3rd quartile  

y_sort = sort(y);
y_Q1 = y_sort(round(length(y_sort)/4));       %approximate 1st quartile
y_Q3 = y_sort(round(length(y_sort)*3/4));     %approximate 3rd quartile

x_frame = [min(x), x_Q1, mean(x), x_Q3, max(x)];
y_frame = [min(y), y_Q1, mean(y), y_Q3, max(y)];

%% plot the data
% we can use a simple plot command, as the changes are made at the axis level
% instead of at the figure level.
plot(x, y, '.');

% apply a range frame to the data we are interested in
ax1 = rangeframe(gca, x_frame, y_frame);

% we can make changes to the axis after it is returned from the rangeframe function
set(ax1, 'DefaultTextInterpreter', 'Latex');    %use the latex font interpreter
set(ax1, 'XTick', [0, 1, 2, 3, 4], ...          %set the axis values to display
         'Ytick', [0, 1, 2, 3, 4]);
  
xlabel(ax1, 'X data');                          %label everything
ylabel(ax1, 'Y data');
title(ax1, 'Statistical data with quartiles and mean');