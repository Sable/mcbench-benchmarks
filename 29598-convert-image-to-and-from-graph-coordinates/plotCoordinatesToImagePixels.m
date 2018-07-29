function pixeliZedScratchPad = plotCoordinatesToImagePixels(x_coordinates, y_coordinates, imageSize)
%PLOTCOORDINATESTOIMAGEPIXELS 

numberOfPoints = length(x_coordinates);
% make into an image by pixelization the coordinates 1st
x_min = min(x_coordinates);
x_max = max(x_coordinates);
y_min = min(y_coordinates);
y_max = max(y_coordinates);

% [use linspace]
% numberOfGratings = 200;
numberOfGratings = imageSize;
unpixelizedRange_x = linspace(x_min, x_max, numberOfGratings);
unpixelizedRange_y = linspace(y_min, y_max, numberOfGratings);

pixelized_x_range = 1:numberOfGratings;
pixelized_y_range = 1:numberOfGratings;

pixeliZedScratchPad = zeros(numberOfGratings, numberOfGratings);

% pixelized the delineating cooridinates
for i = 1:numberOfPoints      
        distances = abs(x_coordinates(i) - unpixelizedRange_x); % find closest distance
        min_distanceIndex = find(min(distances) == distances);
        min_distanceIndexFor_x(i) = min_distanceIndex(1,1); % if there is more than 1, choose 1
        
        distances = abs(y_coordinates(i) - unpixelizedRange_y); % find closest distance
        min_distanceIndex = find(min(distances) == distances);
        min_distanceIndexFor_y(i) = min_distanceIndex(1,1); % if there is more than 1, choose 1
end    

% % pixelized the centroid coordinates
% distances = abs(centreOfShape(1,1) - unpixelizedRange_x);
% min_distanceIndex = find(min(distances) == distances);
% min_distanceIndexFor_Centroid_x0 = min_distanceIndex(1,1); % if there is more than 1, choose 1
% 
% distances = abs(centreOfShape(1,2) - unpixelizedRange_y);
% min_distanceIndex = find(min(distances) == distances);
% min_distanceIndexFor_Centroid_y0 = min_distanceIndex(1,1); % if there is more than 1, choose 1

% % pixelized the centre coordinates
% distances = abs(0 - unpixelizedRange_x);
% min_distanceIndex = find(min(distances) == distances);
% min_distanceIndexFor_x0 = min_distanceIndex(1,1); % if there is more than 1, choose 1
% 
% distances = abs(0 - unpixelizedRange_y);
% min_distanceIndex = find(min(distances) == distances);
% min_distanceIndexFor_y0 = min_distanceIndex(1,1); % if there is more than 1, choose 1

% connect the dots [in the case that the points are insufficient]
%{
increasedNumberOfPoints = 800;  % [TO DO]: automate this param
methodsOfInterpolation = {'spline', 'pchip', 'linear'};
methodOfInterpolationChosen = char(methodsOfInterpolation(1));
pt = interparc(increasedNumberOfPoints,min_distanceIndexFor_x, ...
    min_distanceIndexFor_y, methodOfInterpolationChosen);
min_distanceIndexFor_x = round(pt(:,1));
min_distanceIndexFor_y = round(pt(:,2));
%}
increasedNumberOfPoints = numberOfPoints; % in the case that the points are sufficient
        
% mark the delineating pixels
for i = 1:increasedNumberOfPoints 
    pixeliZedScratchPad(min_distanceIndexFor_x(i), min_distanceIndexFor_y(i)) = 1;
end


% pixeliZedScratchPad(min_distanceIndexFor_Centroid_x0, min_distanceIndexFor_Centroid_y0) = 1; % mark the centroid pixel
% pixeliZedScratchPad(min_distanceIndexFor_x0, min_distanceIndexFor_y0) = 1; % mark the centre pixel relative to the plot

% invert it
pixeliZedScratchPad = ~pixeliZedScratchPad;

% plot right side up
pixeliZedScratchPad = pixeliZedScratchPad';
pixeliZedScratchPad = flipud(pixeliZedScratchPad);


end

