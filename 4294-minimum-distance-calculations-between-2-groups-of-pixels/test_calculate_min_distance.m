%                               431-400 Year Long Project 
%                               LA1 - Medical Image Processing 2003
% Supervisor     :  Dr Lachlan Andrew
% Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                   Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                   Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
%
% File and function name : test_calculate_min_distance
% Version                : 1.0
% Date of completion     : 6 October 2003   
% Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%
% Input   : 
%           None
% Output  : 
%           None
%
% Description:
%       Test the function "test_calculate_min_distance"
%     
% Usage >> test_calculate_min_distance

function test_calculate_min_distance
% -------------------------------------------------------------------------
case_numbers = [1:1:5];
case_num = -1;
while case_num < 0
    clc
    A = input(strcat('Choose the case number to be processed [',...
                     num2str(min(case_numbers)),'~',...
                     num2str(max(case_numbers)),'] :'),'s');
    A = str2num(A);
    if ~isempty(A)
        if ismember(A,case_numbers)
            case_num = A;
        end
    end
end
% -------------------------------------------------------------------------

switch case_num
case 1
    filename1 = 'test_min_distance1a.tif';
    filename2 = 'test_min_distance1b.tif';
case 2
    filename1 = 'test_min_distance2a.tif';
    filename2 = 'test_min_distance2b.tif';
case 3
    filename1 = 'test_min_distance3a.tif';
    filename2 = 'test_min_distance3b.tif';
case 4
    filename1 = 'test_min_distance4a.tif';
    filename2 = 'test_min_distance4b.tif';
case 5
    filename1 = 'test_min_distance5a.tif';
    filename2 = 'test_min_distance5b.tif';
otherwise
    error('Invalid case number selected');
end

% -------------------------------------------------------------------------
clc
disp('Reading test files :');
disp(strcat('1) ',filename1));
disp(strcat('2) ',filename2));
% -------------------------------------------------------------------------
I = imread(filename1);
I2 = imread(filename2);
[Y,X] = find(I~=0);
edge1 = [X,Y];
[Y,X] = find(I2~=0);
edge2 = [X,Y];
% -------------------------------------------------------------------------
disp('-------------------------------------------------------------------------');
disp('Execute the function "calculate_min_distance"');
tic
[min_distance,matching_coordinates] = calculate_min_distance(edge1,edge2)
toc
disp('');
disp('-------------------------------------------------------------------------');
disp('Execute the function "calculate_min_distance" in testing mode');
tic
[min_distance,matching_coordinates] = calculate_min_distance(edge1,edge2,'testing')
toc
disp('');
disp('-------------------------------------------------------------------------');
