%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
%
%  File and function name : test_sort_coord.m
%  Version                : 2.0
%  Date of completion     : 18 December 2003   
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
% 
% Inputs :
%           None
%
% Outputs :
%           None
%
% Description :
%   Test the clockwise and anti-clockwise sorting function on a circle
% 
% Usage >> test_sort_coord

function test_sort_coord
clc
outlined_image = zeros(100);
outlined_image_coord = plot_circle(50,50,20,'bresenham');
assigned_values = outlined_image_coord(:,1);
assigned_values(:) = 1;
outlined_image = place_values(outlined_image_coord,assigned_values,outlined_image);

[Ycoord,Xcoord] = find(outlined_image>0);

disp(' ');
disp('--------------');
disp(strcat('Number of pixels :',num2str(length(Ycoord))));
disp('--------------');
disp(' ');

temp_image = zeros(size(outlined_image));

% -------------------------------------------------------------------
disp('Display the image via the "find" function');
f = figure;
for n = 1:1:length(Ycoord)
    temp_image(Ycoord(n),Xcoord(n)) = 1;
    imshow(temp_image);
    title('"find" function');
    pause(0.01);
end

% -------------------------------------------------------------------

% Clockwise rotation
disp('Press any key to continue....');
pause;

disp('sort_coord_pixels clockwise');
tic
output_coord = sort_coord_pixel([Xcoord,Ycoord],'clockwise');
toc

disp('Press any key to continue....');
pause;
disp('Display the image via "sort_coord_pixel" function');
temp_image(:) = 0;
for n = 1:1:length(output_coord(:,1))
    temp_image(output_coord(n,2),output_coord(n,1)) = 1;
    imshow(temp_image);
    title('"sort-coord-pixel" function - clockwise');
    pause(0.01);
end

% -------------------------------------------------------------------
% Anti-clockwise rotation
disp('Press any key to continue....');
pause;

disp('sort_coord_pixels anti-clockwise');
tic
output_coord = sort_coord_pixel([Xcoord,Ycoord],'anti-clockwise');
toc

disp('Press any key to continue....');
pause;
disp('Display the image via "sort_coord_pixel" function');
temp_image(:) = 0;
for n = 1:1:length(output_coord(:,1))
    temp_image(output_coord(n,2),output_coord(n,1)) = 1;
    imshow(temp_image);
    title('"sort-coord-pixel" function - anti-clockwise');
    pause(0.01);
end

% ===================================================================
% ===================================================================

% -------------------------------------------------------------------
disp('Press any key to continue....');
pause;
disp('Get image "test_sort1.tif"');
temp_image = imread('test_sort1.tif');
[Ycoord,Xcoord] = find(temp_image~=0);
disp('sort_coord_pixels clockwise');
input_coord = [Xcoord,Ycoord];
disp('------------------------');
tic
output_coord = sort_coord_pixel(input_coord,'clockwise','progress track');
toc
disp('------------------------');
disp('Press any key to continue....');
pause;
disp('Display the image via "sort_coord_pixel" function');
temp_image(:) = 0;
for n = 1:1:length(output_coord(:,1))
    temp_image(output_coord(n,2),output_coord(n,1)) = 1;
    imshow(temp_image);
    title('"sort-coord-pixel" function - clockwise');
    pause(0.01);
end

% -------------------------------------------------------------------
disp('Press any key to continue....');
pause;
disp('Get image "test_sort1.tif"');
temp_image = imread('test_sort1.tif');
[Ycoord,Xcoord] = find(temp_image~=0);
disp('sort_coord_pixels anti-clockwise');
input_coord = [Xcoord,Ycoord];
disp('------------------------');
tic
output_coord = sort_coord_pixel(input_coord,'anti-clockwise','progress track');
toc
disp('------------------------');
disp('Press any key to continue....');
pause;
disp('Display the image via "sort_coord_pixel" function');
temp_image(:) = 0;
for n = 1:1:length(output_coord(:,1))
    temp_image(output_coord(n,2),output_coord(n,1)) = 1;
    imshow(temp_image);
    title('"sort-coord-pixel" function - anti-clockwise');
    pause(0.01);
end

% ===================================================================
% ===================================================================

% -------------------------------------------------------------------
disp('Press any key to continue....');
pause;
disp('Get image "test_sort2.tif"');
temp_image = imread('test_sort2.tif');
[Ycoord,Xcoord] = find(temp_image~=0);
disp('sort_coord_pixels clockwise, 4 connectivity');
input_coord = [Xcoord,Ycoord];
disp('------------------------');
tic
output_coord = sort_coord_pixel(input_coord,'clockwise',4);
toc
disp('------------------------');
disp('Press any key to continue....');
pause;
disp('Display the image via "sort_coord_pixel" function');
temp_image(:) = 0;
for n = 1:1:length(output_coord(:,1))
    temp_image(output_coord(n,2),output_coord(n,1)) = 1;
    imshow(temp_image);
    title('"sort-coord-pixel" function - clockwise');
    pause(0.01);
end

% -------------------------------------------------------------------
disp('Press any key to continue....');
pause;
disp('Get image "test_sort2.tif"');
temp_image = imread('test_sort2.tif');
[Ycoord,Xcoord] = find(temp_image~=0);
disp('sort_coord_pixels anti-clockwise, 4 connectivity');
input_coord = [Xcoord,Ycoord];
disp('------------------------');
tic
output_coord = sort_coord_pixel(input_coord,'anti-clockwise',4);
toc
disp('------------------------');
disp('Press any key to continue....');
pause;
disp('Display the image via "sort_coord_pixel" function');
temp_image(:) = 0;
for n = 1:1:length(output_coord(:,1))
    temp_image(output_coord(n,2),output_coord(n,1)) = 1;
    imshow(temp_image);
    title('"sort-coord-pixel" function - anti-clockwise');
    pause(0.01);
end

% ===================================================================
% ===================================================================

disp('Press any key to Close figure....');
pause;
close(f)