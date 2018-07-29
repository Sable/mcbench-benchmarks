function [P, J] = regionGrowing(cIM, initPos, thresVal, maxDist, tfMean, tfFillHoles, tfSimplify)
% REGIONGROWING Region growing algorithm for 2D/3D grayscale images
%
% Syntax:
%   P = regionGrowing();
%   P = regionGrowing(cIM);
%   P = regionGrowing(cIM, initPos)
%   P = regionGrowing(..., thresVal, maxDist, tfMean, tfFillHoles, tfSimpl)
%   [P, J] = regionGrowing(...);
%
% Inputs:
%          cIM: 2D/3D grayscale matrix                      {current image}
%      initPos: Coordinates for initial seed position     {ginput position}
%     thresVal: Absolute threshold level to be included     {5% of max-min}
%      maxDist: Maximum distance to the initial position in [px]      {Inf}
%       tfMean: Updates the initial value to the region mean (slow) {false}
%  tfFillHoles: Fills enclosed holes in the binary mask              {true}
%   tfSimplify: Reduces the number of vertices {true, if dpsimplify exists}
%
% Outputs:
%   P: VxN array (with V number of vertices, N number of dimensions)
%      P is the enclosing polygon for all associated pixel/voxel
%   J: Binary mask (with the same size as the input image) indicating
%      1 (true) for associated pixel/voxel and 0 (false) for outside
%   
% Examples:
%   % 2D Example
%   load example
%   figure, imshow(cIM, [0 1500]), hold all
%   poly = regionGrowing(cIM, [], 300); % click somewhere inside the lungs
%   plot(poly(:,1), poly(:,2), 'LineWidth', 2)
%   
%   % 3D Example
%   load mri
%   poly = regionGrowing(squeeze(D), [66,55,13], 60, Inf, [], true, false);
%   plot3(poly(:,1), poly(:,2), poly(:,3), 'x', 'LineWidth', 2)
%
% Requirements:
%   TheMathWorks Image Processing Toolbox for bwboundaries() and axes2pix()
%   Optional: Line Simplification by Wolfgang Schwanghart to reduce the 
%             number of polygon vertices (see the MATLAB FileExchange)
%
% Remarks:
%   The queue is not preallocated and the region mean computation is slow.
%   I haven't implemented a preallocation nor a queue counter yet for the
%   sake of clarity, however this would be of course more efficient.
%
% Author:
%   Daniel Kellner, 2011, braggpeaks{}googlemail.com
%   History: v1.00: 2011/08/14


% error checking on input arguments
if nargin > 7
    error('Wrong number of input arguments!')
end

if ~exist('cIM', 'var')
    himage = findobj('Type', 'image');
    if isempty(himage) || length(himage) > 1
        error('Please define one of the current images!')
    end
    
    cIM = get(himage, 'CData');
end

if ~exist('initPos', 'var') || isempty(initPos)
    himage = findobj('Type', 'image');
    if isempty(himage)
        himage = imshow(cIM, []);
    end
    
    % graphical user input for the initial position
    p = ginput(1);
    
    % get the pixel position concerning to the current axes coordinates
    initPos(1) = round(axes2pix(size(cIM, 2), get(himage, 'XData'), p(2)));
    initPos(2) = round(axes2pix(size(cIM, 1), get(himage, 'YData'), p(1)));
end

if ~exist('thresVal', 'var') || isempty(thresVal)
    thresVal = double((max(cIM(:)) - min(cIM(:)))) * 0.05;
end

if ~exist('maxDist', 'var') || isempty(maxDist)
    maxDist = Inf;
end

if ~exist('tfMean', 'var') || isempty(tfMean)
    tfMean = false;
end

if ~exist('tfFillHoles', 'var')
    tfFillHoles = true;
end

if isequal(ndims(cIM), 2)
    initPos(3) = 1;
elseif isequal(ndims(cIM),1) || ndims(cIM) > 3
    error('There are only 2D images and 3D image sets allowed!')
end

[nRow, nCol, nSli] = size(cIM);

if initPos(1) < 1 || initPos(2) < 1 ||...
   initPos(1) > nRow || initPos(2) > nCol
    error('Initial position out of bounds, please try again!')
end

if thresVal < 0 || maxDist < 0
    error('Threshold and maximum distance values must be positive!')
end

if ~isempty(which('dpsimplify.m'))
    if ~exist('tfSimplify', 'var')
        tfSimplify = true;
    end
    simplifyTolerance = 1;
else
    tfSimplify = false;
end


% initial pixel value
regVal = double(cIM(initPos(1), initPos(2), initPos(3)));

% text output with initial parameters
disp(['RegionGrowing Opening: Initial position (' num2str(initPos(1))...
      '|' num2str(initPos(2)) '|' num2str(initPos(3)) ') with '...
      num2str(regVal) ' as initial pixel value!'])

% preallocate array
J = false(nRow, nCol, nSli);

% add the initial pixel to the queue
queue = [initPos(1), initPos(2), initPos(3)];


%%% START OF REGION GROWING ALGORITHM
while size(queue, 1)
  % the first queue position determines the new values
  xv = queue(1,1);
  yv = queue(1,2);
  zv = queue(1,3);
 
  % .. and delete the first queue position
  queue(1,:) = [];
    
  % check the neighbors for the current position
  for i = -1:1
    for j = -1:1
      for k = -1:1
            
        if xv+i > 0  &&  xv+i <= nRow &&...          % within the x-bounds?
           yv+j > 0  &&  yv+j <= nCol &&...          % within the y-bounds?          
           zv+k > 0  &&  zv+k <= nSli &&...          % within the z-bounds?
           any([i, j, k])       &&...      % i/j/k of (0/0/0) is redundant!
           ~J(xv+i, yv+j, zv+k) &&...          % pixelposition already set?
           sqrt( (xv+i-initPos(1))^2 +...
                 (yv+j-initPos(2))^2 +...
                 (zv+k-initPos(3))^2 ) < maxDist &&...   % within distance?
           cIM(xv+i, yv+j, zv+k) <= (regVal + thresVal) &&...% within range
           cIM(xv+i, yv+j, zv+k) >= (regVal - thresVal) % of the threshold?

           % current pixel is true, if all properties are fullfilled
           J(xv+i, yv+j, zv+k) = true; 

           % add the current pixel to the computation queue (recursive)
           queue(end+1,:) = [xv+i, yv+j, zv+k];

           if tfMean
               regVal = mean(mean(cIM(J > 0))); % --> slow!
           end
        
        end        
      end
    end  
  end
end
%%% END OF REGION GROWING ALGORITHM


% loop through each slice, fill holes and extract the polygon vertices
P = [];
for cSli = 1:nSli
    if ~any(J(:,:,cSli))
        continue
    end
    
	% use bwboundaries() to extract the enclosing polygon
    if tfFillHoles
        % fill the holes inside the mask
        J(:,:,cSli) = imfill(J(:,:,cSli), 'holes');    
        B = bwboundaries(J(:,:,cSli), 8, 'noholes');
    else
        B = bwboundaries(J(:,:,cSli));
    end
    
	newVertices = [B{1}(:,2), B{1}(:,1)];
	
    % simplify the polygon via Line Simplification
    if tfSimplify
        newVertices = dpsimplify(newVertices, simplifyTolerance);        
    end
    
    % number of new vertices to be added
    nNew = size(newVertices, 1);
    
    % append the new vertices to the existing polygon matrix
    if isequal(nSli, 1) % 2D
        P(end+1:end+nNew, :) = newVertices;
    else                % 3D
        P(end+1:end+nNew, :) = [newVertices, repmat(cSli, nNew, 1)];
    end
end

% text output with final number of vertices
disp(['RegionGrowing Ending: Found ' num2str(length(find(J)))...
      ' pixels within the threshold range (' num2str(size(P, 1))...
      ' polygon vertices)!'])