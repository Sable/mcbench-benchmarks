function plotTimeSeries(res)
% Plot the time series representation of simple harmonic motion

%   Copyright 2008-2009 The MathWorks, Inc.

% res struct has fields Position, Time

plot(res.Time, res.Position, 'b.-')
xlabel('Time (s)');
ylabel('Position');
