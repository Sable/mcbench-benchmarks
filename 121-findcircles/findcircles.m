function [features, count_circles, centers, separation12] = findcircles(input)


% GENERAL PURPOSE:  To provide an example of feature-extraction in a binary image.  
%                   This example could be adapted for other specific requirements.
%
% NOTE:             Requires IMCIRCLE.M, also provided in the MATLAB image userfiles.
%
% SPECIFIC PURPOSE: To identify features in a binary image, to locate circles among the 
%                   features, their centers and the distance between the first two.
%
% SYNOPSIS: [features, count_circles, centers, separation12] = findcircles(input)
%
% DESCRIPTION: Features are assumed to be made up of ones, against a background of zeros.
%              The program makes an effort to remove outliers and stray pixels (line 47).
%              Features are isolated using MATLAB's morphological routine BWLABEL. 
%              Conceptually, a square is drawn around each separate feature, then the
%              feature is compared with a circle occupying the same square. If it
%              resembles the circle to within a certain tolerance (line 40), the feature 
%              is counted as a circle. Features are not considered if they are smaller than 
%              a preset size (line 43). The program also finds the distance between the 
%              centers of the first two circles found. Circles may be missed if they are
%              only partly in the image (i.e. at the edges).
%
% EXAMPLE: Experiment on a blank image by adding features from among the 5 below.
%          (Include the file imcircle.m in the MATLAB working directory  -- see NOTE above)
%
%          myimage = zeros(100);                % blank image
%          myimage(51:56,52:57) = imcircle(6);  % feature 1 (circle)
%          myimage(3:29,13:39)  = imcircle(27); % feature 2 (circle) 
%          myimage(51:65,82:96) = imcircle(15); % feature 3 (circle)
%          myimage(71:90,12:31) = ones(20);     % feature 4 (square)
%          myimage(22:36,71:96) = ones(15,26);  % feature 5 (rectangle)
%          imshow(~myimage),shg                 % display image
%
%          [features,count_circles,centers,separation12] = findcircles(myimage)
%
%          features = 5, count_circles = 3; center1 = [15.5 25.5]; center2 = [53 54];
%          center3 = [57.5 88.5], separation12 = 47.10;


tolcirc = 0.15; % Tolerance for deciding if a feature is a circle. Range [0,1]. 
                % To relax the specification, increase tolcirc (circles can be more imperfect).
                % To tighten the specification, decrease tolcirc (only good circles qualify).
tolsize = 3;    % Tolerance for rejecting small features (diameters). Range [1,2,3...]
                % To accept all features (diameters), even one pixel, set to 1.
                % To reject ever larger features, increase to higher integers.
               
disp(' '),disp('To operate FINDCIRCLES, you must include IMCIRCLE.M in the working directory.')
disp('IMCIRCLE.M is provided in the image section of MATLAB user-donated files.'),disp(' ')
if length(find(input~=0 & input~=1)) > 0, error('Input must be binary'), end
input = bwmorph(bwmorph(bwmorph(input,'spur'),'clean'),'fill');
[numbers,features] = bwlabel(input);
count_circles = 0; centers = [0 0]; separation12 = []; 


for i = 1:features
   [I,J] = find(numbers == i);
   rows = min(I):max(I); columns = min(J):max(J);
   rows = min(rows):min([size(input,1) min(rows)+max([length(rows) length(columns)])-1]);
   columns = min(columns):min([size(input,2) min(columns)+max([length(rows) length(columns)])-1]);
   testitem = input(rows,columns); % testitem is a square containing the feature.
   diameter = max([length(rows) length(columns)]); 
   circle = imcircle(diameter);
   circle = circle(1:length(rows),1:length(columns)); % circle is compared to testitem.
   if (length(find(xor(testitem,circle))) < round(tolcirc*diameter^2)) & (diameter >= tolsize)...
      & length(rows)/length(columns) >= 0.5 & length(rows)/length(columns) <= 2,
      count_circles = count_circles + 1; 
      center_rows = rows(1):rows(1)+diameter-1;
      center_columns = columns(1):columns(1)+diameter-1;
      centers(count_circles,:) = mean([center_rows;center_columns]')-0.5;
   end 
end


if count_circles > 1, separation12 = norm(centers(2,:)-centers(1,:)); end
