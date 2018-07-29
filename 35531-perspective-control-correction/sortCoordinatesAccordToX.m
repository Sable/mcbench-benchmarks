function coordinates = sortCoordinatesAccordToX( coordinates )
%SORTCOORDINATESACCORDTOX Summary of this function goes here

X_sorted_coordinates = sort(coordinates);

    for i=1:length(coordinates)
        for j=1:length(coordinates) % scan thru the X_sorted_coordinates set
            if X_sorted_coordinates(j,1) == coordinates(i,1)
            reordered_coordinates(j,:) = coordinates(i,:);
            end
        end        
    end
    
    coordinates = reordered_coordinates;
end
