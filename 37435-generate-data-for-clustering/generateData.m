function [data clustPoints idx centers slopes lengths] = generateData( ...
    slope, ...
    slopeStd, ...
    numClusts, ...
    xClustAvgSep, ...
    yClustAvgSep, ...
    lengthAvg, ...
    lengthStd, ...
    lateralStd, ...
    totalPoints ...
    )
% generateData Generates 2D data for clustering; data is created along 
%              straight lines, which can be more or less parallel depending
%              on slopeStd argument.
%
% Inputs:
%        slope - Base direction of the lines on which clusters are based.
%     slopeStd - Standard deviation of the slope; used to obtain a random
%                slope variation from the normal distribution, which is
%                added to the base slope in order to obtain the final slope
%                of each cluster.
%    numClusts - Number of clusters (and therefore of lines) to generate.
% xClustAvgSep - Average separation of line centers along the X axis.
% yClustAvgSep - Average separation of line centers along the Y axis.
%                line centers along each dimension.
%    lengthAvg - The base length of lines on which clusters are based.
%    lengthStd - Standard deviation of line length; used to obtain a random
%                length variation from the normal distribution, which is
%                added to the base length in order to obtain the final
%                length of each line.
%   lateralStd - "Cluster fatness", i.e., the standard deviation of the 
%                distance from each point to the respective line, in both x 
%                and y directions; this distance is obtained from the 
%                normal distribution.
%  totalPoints - Total points in generated data (will be 
%                randomly divided among clusters).
%
% Output:
%         data - Matrix (totalPoints x 2) with the generated data
%  clustPoints - Vector (numClusts x 1) containing number of points in each 
%                cluster
%          idx - Vector (totalPoints x 1) containing the cluster indices of 
%                each point
%      centers - Matrix (numClusts x 2) containing centers from where
%                clusters were generated
%       slopes - Vector (numClusts x 1) containing the effective slopes 
%                used to generate clusters
%      lengths - Vector (numClusts x 1) containing the effective lengths 
%                used to generate clusters
%
% ----------------------------------------------------------
% Usage example:
%
%   [data cp idx] = generateData(1, 0.5, 5, 15, 15, 5, 1, 2, 200);
%
% This creates 5 clusters with a total of 200 points, with a base slope 
% of 1 (std=0.5), separated in average by 15 units in both x and y 
% directions, with average length of 5 units (std=1) and a "fatness" or
% spread of 2 units.
%
% To take a quick look at the clusters just do:
%
%   scatter(data(:,1), data(:,2), 8, idx);
% ----------------------------------------------------------
%
%  N. Fachada
%  Instituto Superior Técnico
%  Aug 10, 2010
%  Updated: Aug 2, 2012

% Make sure totalPoints >= numClusts
if totalPoints < numClusts
    error('Number of points must be equal or larger than the number of clusters.');
end;

% Determine number of points in each cluster
clustPoints = abs(randn(numClusts, 1));
clustPoints = clustPoints / sum(clustPoints);
clustPoints = round(clustPoints * totalPoints);

% Make sure totalPoints is respected
while sum(clustPoints) < totalPoints
    % If one point is missing add it to the smaller cluster
    [C,I] = min(clustPoints);
    clustPoints(I(1)) = C + 1;
end;
while sum(clustPoints) > totalPoints
    % If there is one extra point, remove it from larger cluster
    [C,I] = max(clustPoints);
    clustPoints(I(1)) = C - 1;
end;

% Make sure there are no empty clusters
emptyClusts = find(clustPoints == 0);
if ~isempty(emptyClusts)
    % If there are empty clusters...
    numEmptyClusts = size(emptyClusts, 1);
    for i=1:numEmptyClusts
        % ...get a point from the largest cluster and assign it to the
        % empty cluster
        [C,I] = max(clustPoints);
        clustPoints(I(1)) = C - 1;
        clustPoints(emptyClusts(i)) = 1;
    end;
end;

% Initialize data matrix
data = zeros(sum(clustPoints), 2);

% Initialize idx (vector containing the cluster indices of each point)
idx = zeros(totalPoints, 1);

% Initialize lengths vector
lengths = zeros(numClusts, 1);

% Determine cluster centers
xCenters = xClustAvgSep * numClusts * (rand(numClusts, 1) - 0.5);
yCenters = yClustAvgSep * numClusts * (rand(numClusts, 1) - 0.5);
centers = [xCenters yCenters];

% Determine cluster slopes
slopes = slope + slopeStd * randn(numClusts, 1);

% Create clusters
for i=1:numClusts
    % Determine length of line where this cluster will be based
    lengths(i) = abs(lengthAvg + lengthStd*randn);
    % Determine how many points have been assigned to previous clusters
    sumClustPoints = 0;
    if i > 1
        sumClustPoints = sum(clustPoints(1:(i - 1)));
    end;
    % Create points for this cluster
    for j=1:clustPoints(i)
        % Determine where in the line the next point will be projected
        position = lengths(i) * rand - lengths(i) / 2;
        % Determine x coordinate of point projection
        delta_x = cos(atan(slopes(i))) * position;
        % Determine y coordinate of point projection
        delta_y = delta_x * slopes(i);
        % Get point distance from line in x coordinate
        delta_x = delta_x + lateralStd * randn;
        % Get point distance from line in y coordinate
        delta_y = delta_y + lateralStd * randn;
        % Determine the actual point
        data(sumClustPoints + j, :) = [(xCenters(i) + delta_x) (yCenters(i) + delta_y)];
    end;
    % Update idx
    idx(sumClustPoints + 1 : sumClustPoints + clustPoints(i)) = i;
end;