function [plotCoordinates_x plotCoordinates_y] = mapPixelsToCoordinatedPlotGraph(pixeliZedScratchPad, ...
            upperRangeX, lowerRangeX, lowerRangeY, upperRangeY)
%MAPPIXELSTOCOORDINATEDPLOTGRAPH 
% Caveat: center of plot may be required
% plot right side up (plot and graph center is different)
pixeliZedScratchPad = pixeliZedScratchPad';
% pixeliZedScratchPad = flipud(pixeliZedScratchPad);
pixeliZedScratchPad = fliplr(pixeliZedScratchPad);
% pixeliZedScratchPad = im2bw(pixeliZedScratchPad);
% imshow(pixeliZedScratchPad, []);

[rowSizeOfImage colSizeOfImage] = size(pixeliZedScratchPad);

x_min = lowerRangeX; 
x_max = upperRangeX;
y_min = lowerRangeY;
y_max = upperRangeY;

% rowSizeOfImage == plotWidth; colSizeOfImage == plotHeight;
x_coordinatesMap = linspace(x_min, x_max, rowSizeOfImage);
y_coordinatesMap = linspace(y_min, y_max, colSizeOfImage);

stepSize_x = x_coordinatesMap(1,2) - x_coordinatesMap(1,1);
stepSize_y = y_coordinatesMap(1,2) - y_coordinatesMap(1,1);

[x_coordinates y_coordinates] = find(uint8(pixeliZedScratchPad) == 1);
% remap the coordinates ('normalized')
% get the demarcations
x_plot_min = min(x_coordinates(:)); 
x_plot_max = max(x_coordinates(:)); 
y_plot_min = min(y_coordinates(:)); 
y_plot_max = max(y_coordinates(:));

x_coordinates = x_coordinates*stepSize_x;
y_coordinates = y_coordinates*stepSize_y;

if (x_min <= 0)
    x_coordinates = x_coordinates + x_min; % may have to (-1) because mapping starts at 1, thence, it must be brought to zero 1st
end

if (y_min <= 0)
    y_coordinates = y_coordinates + y_min; % may have to (-1) because mapping starts at 1, thence, it must be brought to zero 1st
end

plotCoordinates_x = x_coordinates;
plotCoordinates_y = y_coordinates;

% plot(x_coordinates, y_coordinates, 'x');
% axis([lowerRangeX upperRangeX lowerRangeY upperRangeY]);
% grid on;
% imshow(uint8(pixeliZedScratchPad), []);

end
