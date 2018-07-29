%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
% 
%  File and function name : test_find_skel_intersection.m.m
%  Version                : 1.0
%  Date of completion     : 17 October 2003   
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%
%  Inputs        :  
%           None
%  Outputs       :          
%           None
%
%  Description   : 
%       Tests the function "find_skel_intersection.m"
%
%  To Run >> test_find_skel_intersection.m
%

function test_find_skel_intersection
case_list = [1:1:7];
% -------------------------------------------------------------------------------------
case_num = -1;
while case_num < 0
    clc
    disp('- case 1~3');
    disp('      Skeleton test case');
    disp('- case 4');
    disp('      No branching test case');
    disp('- Case 5 ');
    disp('      Single branching test case');
    disp('- Case 6 ');
    disp('      Same as case 5 but without using "bwmorph"');
    disp('      to find the skeleton');
    disp('      Case 6 is to show that this program was ');
    disp('      NOT meant to run on the original island');
    disp('      but on its skeleton only');
    disp('      THIS CASE MAY TAKE MORE TIME TO RUN THEN USUAL');
    disp('- Case 7');
    disp('      Test case with multiple end points');
    disp('----------------------------------------------------------------------------------')
    A = input(strcat('Select case number [',num2str(min(case_list)),...
                     '~',num2str(max(case_list)),'] :'),'s');
	A = str2num(A);
    if ~isempty(A)
        if ismember(A,case_list)
            case_num = A;
        end
    end
end
clc

% -------------------------------------------------------------------------------------
% Read in the selected file and process its skeleton
% -------------------------------------------------------------------------------------
switch case_num
case 1
    filename = 'test_find_skel_intersection1.tif';
	original_image = imread(filename);
	input_skeleton_image = bwmorph(original_image,'thin',inf);
case 2
    filename = 'test_find_skel_intersection2.tif';
	original_image = imread(filename);
	input_skeleton_image = bwmorph(original_image,'thin',inf);
case 3
    filename = 'test_find_skel_intersection3.tif';
	original_image = imread(filename);
	input_skeleton_image = bwmorph(original_image,'thin',inf);
case 4
    filename = 'test_find_skel_intersection4.tif';
	original_image = imread(filename);
	input_skeleton_image = bwmorph(original_image,'thin',inf);
case 5
    filename = 'test_find_skel_intersection5.tif';
	original_image = imread(filename);
	input_skeleton_image = bwmorph(original_image,'thin',inf);
case 6
    filename = 'test_find_skel_intersection6.tif';
	original_image = imread(filename);
	input_skeleton_image = original_image;
case 7
    filename = 'test_find_skel_intersection7.tif';
	original_image = imread(filename);
	input_skeleton_image = bwmorph(original_image,'thin',inf);
otherwise
    error('Invalid case selection');
end
% -------------------------------------------------------------------------------------

disp(strcat('Selected file :',filename));
disp('---------------------------------------------------------------------');
disp('function "find_skel_intersection.m"');
tic
intersection_pts = find_skel_intersection(input_skeleton_image)
toc

disp('');
disp('---------------------------------------------------------------------');
disp('function "find_skel_ends" with "testing" option');
tic
intersection_pts = find_skel_intersection(input_skeleton_image,'testing')
toc

disp('---------------------------------------------------------------------');
disp('Display the original image and the skeleton image');
figure,
imshow(original_image);
title(filename);
