%
%
%
%  Test the data density plot
%
%
x = randn(2048, 1);
y = randn(2048, 1);
x(1:512) = x(1:512) + 2.75;
x(1537:2048) = x(1537:2048) + 2.75;
y(1025:2048) = y(1025:2048) + 2.75;

% On scatter plot you probably can't see the data density
scatter(x, y);
% On data density plot the structure should be visible
DataDensityPlot(x, y, 32);
