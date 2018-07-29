function concurrencyPoints = traceConcurrencyPoints( boundaryPoints, cornerPoints )
%TRACECONCURRENCYPOINTS 
%   
variance = 0;

sizeOfBoundaryPoints = size(boundaryPoints); % 1 element of the vector is the number of row
sizeOfCornerPoints = size(cornerPoints); % 1 element of the vector is the number of row
numberOfConcurrencyPoints = 0;

numberOfToleratedPoints = 0;

    for i=1:sizeOfBoundaryPoints(1)
        for j=1:sizeOfCornerPoints(1)
            if boundaryPoints(i,1) == cornerPoints(j,1) & boundaryPoints(i,2) == cornerPoints(j,2)
                numberOfConcurrencyPoints = numberOfConcurrencyPoints + 1;
                concurrencyPoints (numberOfConcurrencyPoints,1) = cornerPoints(j,1);
                concurrencyPoints (numberOfConcurrencyPoints,2) = cornerPoints(j,2);                
            end    
            
            % tolerance implicated
            if (abs(boundaryPoints(i,1) - cornerPoints(j,1)) + abs(boundaryPoints(i,2) - cornerPoints(j,2))) < variance 
            %if (abs(boundaryPoints(i,1) - cornerPoints(j,1)) < variance) 
            %    if (abs(boundaryPoints(i,2) - cornerPoints(j,2)) < variance)
                numberOfConcurrencyPoints = numberOfConcurrencyPoints + 1;
                                numberOfToleratedPoints = numberOfToleratedPoints +1;
                
                concurrencyPoints (numberOfConcurrencyPoints,1) = cornerPoints(j,1);
                concurrencyPoints (numberOfConcurrencyPoints,2) = cornerPoints(j,2);     
            %    end
            %end
            end
            
        end
    end   
    
    disp(numberOfToleratedPoints);
end
