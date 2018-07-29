% Create diagram
function Example
figure(1)
clf
hold on

x = [1:10];

plot(x, x + 0.0, 'b', 'LineWidth', 2, 'DisplayName', 'First')
plot(x, x + 0.2, 'r', 'LineWidth', 2, 'DisplayName', 'First')
plot(x, x + 0.4, 'g', 'LineWidth', 2, 'DisplayName', 'First')
plot(x, x + 0.6, 'c', 'LineWidth', 2, 'DisplayName', 'First')
plot(x, x + 0.8, 'k', 'LineWidth', 2, 'DisplayName', 'First')

plot(x, 0*x + 5 + 0.0, 'b-', 'LineWidth', 1)
plot(x, 0*x + 5 + 0.2, 'r-', 'LineWidth', 1)
plot(x, 0*x + 5 + 0.4, 'g-', 'LineWidth', 1)

plot(x, 0*x + 5 + 0.4, 'g--', 'LineWidth', 1)
plot(x, 0*x + 5 + 0.6, 'c--', 'LineWidth', 1)
plot(x, 0*x + 5 + 0.8, 'k--', 'LineWidth', 1)

hold off

% Add first legend (the usual way)
legend({'First', 'Second', 'Third', 'Fourth', 'Fifth'}, 'Location', 'NorthWest')

% Add three more legends
legend_data = cell('');

% First additional
legend_data{1}{1} = struct('LineStyle', '-',	'LineWidth', 1, 'Color', [0 0 0], 'Marker', 'none', 'MarkerSize', 6, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'DisplayName', 'Solid');
legend_data{1}{2} = struct('LineStyle', '--',	'LineWidth', 1, 'Color', [0 0 0], 'Marker', 'none', 'MarkerSize', 6, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'DisplayName', 'Dashed');
legend_data{1}{3} = struct('LineStyle', ':',	'LineWidth', 1, 'Color', [0 0 0], 'Marker', 'none',	'MarkerSize', 6, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'DisplayName', 'Dotted');
legend_data{1}{4} = struct('LineStyle', '-.',	'LineWidth', 1, 'Color', [0 0 0], 'Marker', 'none',	'MarkerSize', 6, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'DisplayName', 'Dash-dotted');

% second additional
legend_data{2}{1} = struct('LineStyle', '-',	'LineWidth', 2, 'Color', [0 0 0], 'Marker', 'none', 'MarkerSize', 6, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'DisplayName', 'Thick');
legend_data{2}{2} = struct('LineStyle', '-',	'LineWidth', 1, 'Color', [0 0 0], 'Marker', 'none', 'MarkerSize', 6, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'DisplayName', 'Thin');

% third legend
legend_data{3}{1} = struct('LineStyle', 'none', 'DisplayName', 'I''m also a legend!');

legend_settings.Location	= {'SouthEast', 'South', 'NorthOutside'};
legend_settings.Orientation = {'Vertical', 'Horizontal', 'Horizontal'};
% legend_settings.TextColor	= {'r', 'b', 'w'};
% legend_settings.Color	= {'w', 'w', 'k'};

AddMultipleLegends(1, gca, legend_data, legend_settings);