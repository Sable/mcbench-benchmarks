function PlotTempData(city, xData, localAnomData, fitval, latStr, lngStr)
%#event
xlabelData = xData{1};
xticks = xData{2};
xtickValues = xticks{1};
xtickLabels = xticks{2};

% Draw a pretty picture
figure;
hold on
plot(xlabelData, localAnomData, 'b.', 'MarkerSize', 4);
line(xlabelData, fitval, 'Color', 'red', 'LineWidth', 2);
hold off
set(gca, 'XLim', [xlabelData(1), xlabelData(end)]);
set(gca, 'XTick', xtickValues, 'XTickLabel', xtickLabels);

% Annotate the plot
titleStr = sprintf(['Monthly Local Temperature Anomaly\nLatitude %s   ' ...
                    'Longitude %s\nGrid Center: %s'], latStr, lngStr, ...
                    city);
title(titleStr, 'FontWeight', 'Bold');

xlabel('Date', 'FontWeight', 'Bold');
ylabel('Variance Degrees Centigrade', 'FontWeight', 'Bold');
