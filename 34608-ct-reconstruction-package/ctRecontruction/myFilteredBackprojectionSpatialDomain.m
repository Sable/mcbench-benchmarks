function BPI = myFilteredBackprojectionSpatialDomain(sinogram,thetas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filtered back projection in the spatial domain -> schlegel & bille 9.3.1
% modified by: Mark Bangert
% m.bangert@dkfz.de 2011
%
% note: matlab puts the 0 frequency component of a fourier spectrum _not_
%       in the middle. we need to fumble around with fftshift

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

% set up filter: now for the spatial domain!!!
filterMode = 'sheppLogan'; % put either 'sheppLogan' or 'ramLak'

if mod(numOfParallelProjections,2) == 0
    halfFilterSize = floor(1 + numOfParallelProjections);
else
    halfFilterSize = floor(numOfParallelProjections);
end

if strcmp(filterMode,'ramLak')
    filter = zeros(1,halfFilterSize);
    filter(1:2:halfFilterSize) = -1./([1:2:halfFilterSize].^2 * pi^2);
    filter = [fliplr(filter) 1/4 filter];
elseif strcmp(filterMode,'sheppLogan')
    filter = -2./(pi^2 * (4 * (-halfFilterSize:halfFilterSize).^2 - 1) );
end

% loop over each projection
for i = 1:numOfAngularProjections

    % figure out which projections to add to which spots
    rotCoords = round(midindex + xCoords*sin(thetas(i)) + yCoords*cos(thetas(i)));

    % check which coords are in bounds
    indices   = find((rotCoords > 0) & (rotCoords <= numOfParallelProjections));
    newCoords = rotCoords(indices);
        
    % filter
    filteredProfile = conv(sinogram(:,i),filter,'same');

    % summation
    BPI(indices) = BPI(indices) + filteredProfile(newCoords)./numOfAngularProjections;
    
    % visualization on the fly
    imagesc(BPI)
    drawnow

end
