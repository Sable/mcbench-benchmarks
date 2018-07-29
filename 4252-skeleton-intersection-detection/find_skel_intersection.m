%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
% 
%  File and function name : find_skel_intersection.m
%  Version                : 1.0
%  Date of completion     : 17 October 2003   
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%
%  Inputs        :  
%               input_skeleton_image - binary image of 1 island representing the 
%                                      skeleton.
%               'not testing','testing' (Optional) - Enables or disables testing mode
%                                                    (Default - 'not testing')
%
%  Outputs       :          
%               intersecting_pts - [X,Y] coordinates of where the intersection points 
%                                  of the skeleton are.
%
%  Description   : 
%       Determines the locations of the intersection points in the given skeleton.
%
%  To Run >> intersecting_pts = find_skel_intersection(input_skeleton_image)
%
% Example >> I = imread(filename);
%           input_skeleton_image = bwmorph(I,'thin',inf);
%           intersecting_pts = find_skel_intersection(input_skeleton_image);
%           figure,imshow(input_skeleton_image);
%           hold on; plot(intersecting_pts(:,1),intersecting_pts(:,2),'r*');
%
%                       or
%
%            I = imread(filename);
%           input_skeleton_image = bwmorph(I,'thin',inf);
%           intersecting_pts = find_skel_intersection(input_skeleton_image,'testing');
%           

function intersecting_pts = find_skel_intersection(input_skeleton_image,varargin)
option = 'not testing';
if ~isempty(varargin)
    for n = 1:1:length(varargin)
        if strcmp(varargin{n},'testing') | strcmp(varargin{n},'not testing')
            option = varargin{n};
        else
            error('Error in input option');
        end
    end
end

% ---------------------------------------------------------------------------------------------
input_skeleton_image = double(input_skeleton_image) ./ double(max(input_skeleton_image(:)));
% ---------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------------
if strcmp(option,'testing')
	disp('Process the skeleton to find the intersection of the island');
end
kernel = [1 1 1; 1 1 1; 1 1 1];
conv_img = conv2(input_skeleton_image,kernel,'same');
conv_img = conv_img .* input_skeleton_image;
[Y,X] = find(conv_img > 3);

% ---------------------------------------------------------------------------------------------
% If there are intersecting points, select only 1 pixel from each island of
% intersection points
% ---------------------------------------------------------------------------------------------
intersecting_pts = [];
if ~isempty(X)
	classes = sortclasses([X,Y],1,8);
	for n = 1:1:length(classes)
        X = mean(classes{n}(:,1));
        Y = mean(classes{n}(:,2));
        temp = classes{n};
        temp(:,1) = X;
        temp(:,2) = Y;
        distance = euclidean_distance(temp,classes{n});
        temp = sortrows([distance,classes{n}]);
        intersecting_pts = [intersecting_pts;temp(1,[2,3])];
	end
else
end
% ---------------------------------------------------------------------------------------------
% If testing then display the skeleton image with the detected end points
% ---------------------------------------------------------------------------------------------
if strcmp(option,'testing')
    disp('Display the intersection ends');
	figure;
    imshow(input_skeleton_image);
	hold on;
    if ~isempty(intersecting_pts)
    	plot(intersecting_pts(:,1),intersecting_pts(:,2),'r*');
    end
    title('Red points indicated detected intersection points');
    xlabel('Test mode for "find skel ends.m" function');
end
