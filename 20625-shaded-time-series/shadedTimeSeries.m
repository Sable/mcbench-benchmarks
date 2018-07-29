function shadedTimeSeries(X, Ydata, indicator, Xlabel, Ylabels, colour, Yspacing)
% SHADEDTIMESERIES(X, Ydata, indicator, Xlabel, Ylabels, colour, Yspacing)
%
% Plot time series one above the other with coloured strips highlighting
% interesting features.
%
% All data is in columns.
%
% X is the time vector.
% Each column of Ydata will be plotted in a separate subplot, one beneath
% the other.
% Indicator is a logical array where the ones indicate the areas of
% interest that will be shaded.
% Xlabel is a string for labeling the bottom horizontal axis.
% Ylabels is a cell array of strings used for labeling the Y axes.
% Colour is an RGB colour array that will be used for shading.
% Yspacing is the percentage of vertical padding to leave above and below
% each plot so that they don't touch the top and bottom of their respective
% plots.
%
% If Ydata has only one column then the function will draw in the current
% plot or subplot; this is useful if you want to organise your own plots
% and subplots but still use the shading feature. If Ydata has more than
% one column then the function will create a new figure with a subplot for
% each column of Ydata.
%
% Example 1 - same indicator for all subplots: 
%           time = [1:50]';
%           acceleration = rand(50,1);
%           velocity = cumtrapz(acceleration, time);
%           position = cumtrapz(velocity, time);
%           indicator = [zeros(1,10) ones(1,10) zeros(1,25) ones(1,5)]';
%           shadedTimeSeries(time, [acceleration velocity position], indicator, 'Time', {'Acceleration' 'Velocity' 'Position'}, [0 0.8 0.3], 10);
%
%
% Example 2 - different indicators for each subplot: 
%           time = [1:50]';
%           acceleration = rand(50,1);
%           velocity = cumtrapz(acceleration, time);
%           position = cumtrapz(velocity, time);
%           indicator = [zeros(1,10) ones(1,10) zeros(1,25) ones(1,5); ones(1,3) zeros(1,10) ones(1,30) zeros(1,7); zeros(1,20) ones(1,20) zeros(1,10)]';
%           shadedTimeSeries(time, [acceleration velocity position], indicator, 'Time', {'Acceleration' 'Velocity' 'Position'}, [0 0.8 0.3], 10);
%
%    
%
% Example 3 - single plot at a time for full control: 
%           time = [1:50]';
%           acceleration = rand(50,1);
%           velocity = cumtrapz(acceleration, time);
%           position = cumtrapz(velocity, time);
%           indicator = [zeros(1,10) ones(1,10) zeros(1,25) ones(1,5)]';
%           figure;
%           subplot(3,1,1);
%           shadedTimeSeries(time, acceleration, indicator, 'Time', {'Acceleration'}, [1 .7 1], 10);
%           hold on
%           text(10,1,'Custom text.');
%           subplot(3,1,2);
%           shadedTimeSeries(time, velocity, indicator, 'Time', {'Velocity'}, [1 .7 1], 10);
%           xlabel('');
%           subplot(3,1,3);
%           shadedTimeSeries(time, position, indicator, 'Time', {'Position'}, [1 .7 1], 10);
%           grid on;
%
% Carl Fischer. March 2011.
% http://eis.comp.lancs.ac.uk/~carl/blog/

if nargin < 3
    error('Please provide at least X, Ydata and indicator parameters.');
end
% Check consistency of compulsory parameters first.
if length(X) ~= size(Ydata,1)
    if length(X) == size(Ydata,2)
        Ydata = Ydata';
    else
        error('X and Ydata must have the same length.');
    end
end
if length(X) ~= size(indicator,1)
    if length(X) == size(indicator,2)
        indicator = indicator';
    else
        error('X and indicator must have the same length.');
    end
end
if nargin < 4
    Xlabel = '';
end
if nargin < 5
    Ylabels = cell(1,size(Ydata,2));
end
if nargin < 6 || isempty(colour)
    colour = [0 .7 .7];
end
if nargin < 7 || isempty(Yspacing)
    Yspacing = 5;
end


if length(Ylabels) ~= size(Ydata,2)
    error('The number of Ylabels should match the number of data traces in Ydata.');
end
if size(indicator,2) > 1 && size(indicator,2) ~= size(Ydata,2)
    error('If there is more than one column in indicator, their number must match the number of columns in Ydata.');
end

for column_idx = 1:size(indicator,2)
    start_marks{column_idx} = find(diff(indicator(:,column_idx)) > 0);
    end_marks{column_idx} = find(diff(indicator(:,column_idx)) < 0);
    if start_marks{column_idx}(1) > end_marks{column_idx}(1) % plot is shaded from start
        start_marks{column_idx} = [1; start_marks{column_idx}];
    end
    if start_marks{column_idx}(end) > end_marks{column_idx}(end) % plot is shaded until end
        end_marks{column_idx} = [end_marks{column_idx}; length(X)];
    end
end
if size(Ydata,2) > 1
    figure;
end
for i = 1:size(Ydata,2)
    if size(indicator,2) == 1
        plot_partial(X, Ydata(:,i), start_marks{1}, end_marks{1}, i, Ylabels{i}, size(Ydata,2));
    else
        plot_partial(X, Ydata(:,i), start_marks{i}, end_marks{i}, i, Ylabels{i}, size(Ydata,2));
    end
    if i ~= size(Ydata,2)
        set(gca,'xticklabel',[]) % remove x label for all except bottom plot
    end
end
xlabel(Xlabel);



    function plot_partial(x, ydata, start_marks, end_marks, number, name, total)
        if size(Ydata,2) > 1
            subplot(total,1,number);
        end
        hold on;
        ylabel(name);
        xlim([x(1) x(end)]);% force plot to go from edge to edge
        padding = Yspacing/100*(max(ydata)-min(ydata));% spacing at top and bottom of plotted line
        ylim([min(ydata)-padding max(ydata)+padding]); % default leaves too much space around graph
        
        for j = 1:min(length(start_marks), length(end_marks)) % create all the shaded areas
            % This patch line was ripped from ShadePlotForEmphasis.m by
            % Michael Robbins on Matlab Central.
            patch([repmat( x(start_marks(j)),1,2) repmat( x(end_marks(j)),1,2)], ...
                [get(gca,'YLim') fliplr(get(gca,'YLim'))], ...
                [0 0 0 0],colour,'EdgeColor', 'none');
        end
        plot(x, ydata, 'LineWidth', 3); % plot data line on top of colour patch
        set(gca, 'layer', 'top'); % put ticks back on top of colour patch
        hold off;
    end
end
