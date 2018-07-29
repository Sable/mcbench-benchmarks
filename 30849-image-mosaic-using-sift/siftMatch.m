% [matchLoc1 matchLoc2] = siftMatch(img1, img2)
%
% This function reads two images, finds their SIFT features, and
%   displays lines connecting the matched keypoints.  A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
% It returns the matched points of both images, matchLoc1 = [x1,y1;x2,y2;...]
%
% Example: match('scene.pgm','book.pgm');

function [matchLoc1 matchLoc2] = siftMatch(img1, img2)

% load matchdata
% load img1data
% load img2data
%{,
% Find SIFT keypoints for each image
[des1, loc1] = sift(img1);
[des2, loc2] = sift(img2);
% save img1data des1 loc1
% save img2data des2 loc2

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
matchTable = zeros(1,size(des1,1));
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      matchTable(i) = indx(1);
   else
      matchTable(i) = 0;
   end
end
% save matchdata matchTable
%}

% Create a new image showing the two images side by side.
img3 = appendimages(img1,img2);

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(img3,2) size(img3,1)]);
colormap('gray');
imagesc(img3);
hold on;
cols1 = size(img1,2);
for i = 1: size(des1,1)
  if (matchTable(i) > 0)
    line([loc1(i,2) loc2(matchTable(i),2)+cols1], ...
         [loc1(i,1) loc2(matchTable(i),1)], 'Color', 'c');
  end
end
hold off;
num = sum(matchTable > 0);
fprintf('Found %d matches.\n', num);

idx1 = find(matchTable);
idx2 = matchTable(idx1);
x1 = loc1(idx1,2);
x2 = loc2(idx2,2);
y1 = loc1(idx1,1);
y2 = loc2(idx2,1);

matchLoc1 = [x1,y1];
matchLoc2 = [x2,y2];

end