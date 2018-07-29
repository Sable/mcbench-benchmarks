function BPI = myBackprojection(sinogram,thetas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unfiltered back projection -> schlegel & bille 9.1.2
% modified by: Mark Bangert
% m.bangert@dkfz.de 2011

% figure out how big our picture is going to be.
numOfParallelProjections = size(sinogram,1);
numOfAngularProjections  = length(thetas); 

% convert thetas to radians
thetas = (pi/180)*thetas;

% set up the backprojected image
BPI = zeros(numOfParallelProjections,numOfParallelProjections);

% find the middle index of the projections
midindex = floor(numOfParallelProjections/2) + 1;

% set up the coords of the image
[xCoords,yCoords] = meshgrid(ceil(-numOfParallelProjections/2):ceil(numOfParallelProjections/2-1));

% loop over each projection
for i = 1:numOfAngularProjections

    % figure out which projections to add to which spots
    rotCoords = round(midindex + xCoords*sin(thetas(i)) + yCoords*cos(thetas(i)));

    % check which coords are in bounds
    indices   = find((rotCoords > 0) & (rotCoords <= numOfParallelProjections));
    newCoords = rotCoords(indices);
    
    % summation
    BPI(indices) = BPI(indices) + sinogram(newCoords,i)./numOfAngularProjections;
    
    % visualization on the fly
    imagesc(BPI)
    drawnow

end
