function corner_4_coordinates = Get4Points( corner_coordinates )
%GET4POINTS Summary of this function goes here
%   
variance = 10;   % delta_x + delta_y: The distance of the 4 corners should not <= the designated variance
numberOfPoints = 0; % should be 4 corners eventually for a quadrilateral

%corner_coordinates = sort(corner_coordinates,2);
sizeOfCornerPoints = size(corner_coordinates); % 1 element of the vector is the number of row

delta_x = variance; delta_y = 1;    % ensure (delta_x + delta_y) > variance to start with

% for the 4 corners
numberOfPoint1 = 0; numberOfPoint2 = 0; numberOfPoint3 = 0; numberOfPoint4 = 0;

% get the 4 designated points
        for i=1:sizeOfCornerPoints(1)            
            if (i+1) < sizeOfCornerPoints(1)
                % appoint it as the candidate point
                if (numberOfPoints < 4) & ((delta_x + delta_y) > variance )
                    numberOfPoints = numberOfPoints+1;
                    designatedPoint(numberOfPoints,:) = corner_coordinates(i,:);
                end
                    
                delta_x = abs(designatedPoint(numberOfPoints,1) - corner_coordinates(i+1,1));    % difference of the 2 x values
                delta_y = abs(designatedPoint(numberOfPoints,2) - corner_coordinates(i+1,2));    % difference of the 2 y values
                                               
            end            
        end
        
        corner_4_coordinates = designatedPoint;
end

% Notes
% =====
%  Recommendation: The points may be averaged as well
% 