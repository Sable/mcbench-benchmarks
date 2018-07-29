%% #################### Facial Expression Recognition #####################
%%     This program is written by Md. Iftekhar Tanveer
%%                   (go2chayan@gmail.com)
%% Many conceptions here are taken from:
%% M. Turk and A. Pentland, "Eigenfaces for Recognition", Journal of
%% Cognitive Neuroscience, March 1991
%%
%% =======================================================================
%% If the 'Cropped' or 'Test_Cropped' folder is not ready, run Crop_Face.m
%% =======================================================================
%%
%% This code requires the following toolboxes:
%%          1. Image Processing Toolbox (For Resizing Image)
%%          2. Statistics Toolbox (For PCA)
%% ########################################################################

function [isSucceed] = EigenFace(strTrainPath, strLabelFile, strTestPath)
disp('This Program is written by Md. Iftekhar Tanveer (go2chayan@gmail.com)');
disp('Copyleft 2009');

isSucceed = 0;
if (exist('strTrainPath')==0)
    strTrainPath = input('Enter Train Folder Name:','s');
end
if (exist('strLabelFile')==0)
    strLabelFile = input('Enter Label File Name:','s');
end
if (exist('strTestPath')==0)
    strTestPath = input('Enter Test Folder Name:','s');
end
    
fid=fopen(strLabelFile);
imageLabel=textscan(fid,'%s %s','whitespace',',');
fclose(fid);

NeutralImages=[];
for i=1:length(imageLabel{1,1})
    if (strcmp(lower(imageLabel{1,2}{i,1}),'neutral'))
        NeutralImages=[NeutralImages,i];
    end 
end
if (length(NeutralImages)==0)
    disp('ERROR: Neutral Expression is not available in training');
    return;
end

structTestImages = dir(strTestPath);
numImage = length(imageLabel{1,1});  % Total Observations: Number of Images in training set
lenTest = length(structTestImages);

if (lenTest==0)
    disp('Error:Invalid Test Folder');
    return;
end

TrainImages='';
for i = 1:numImage
	TrainImages{i,1} = strcat(strTrainPath,'\',imageLabel{1,1}(i));
end

j=0;
for i = 3:lenTest
     if ((~structTestImages(i).isdir))
         if  (structTestImages(i).name(end-3:end)=='.jpg')
             j=j+1;
             TestImages{j,1} = [strTestPath,'\',structTestImages(i).name];
         end
     end
end
numTestImage = j; % Number of Test Images
clear ('structTestImages','fid','i','j');pack

imageSize = [280,180];          % All Images are resized into a common size

%% ################# Load Train Data & Preprocess  ########################
%% Loading training images & preparing for PCA by subtracting mean

img = zeros(imageSize(1)*imageSize(2),numImage);
for i = 1:numImage
    aa = imresize(detect_face(imresize(imread(cell2mat(TrainImages{i,1})),[375,300])),imageSize);
    img(:,i) = aa(:);
    disp(sprintf('Loading Train Image # %d',i));
end
meanImage = mean(img,2);        
                 
img = (img - meanImage*ones(1,numImage))';      % img is the input to PCA
%% ########################################################################

%% ################# Low Dimension Face Space Construction ################
[C,S,L]=princomp(img,'econ');                   % Performing PCA Here
EigenRange = [1:30];   % Defines which Eigenvalues will be selected
C = C(:,EigenRange);
%% ########################################################################


%% ############# Load Test Data and project on Face Space #################
img = zeros(imageSize(1)*imageSize(2),numTestImage);
for i = 1:numTestImage
    aa = imresize(detect_face(imresize(imread(TestImages{i,1}),[375,300])),imageSize);
    img(:,i) = aa(:);
    disp(sprintf('Loading Test Image # %d',i));
end
meanImage = mean(img,2);        
img = (img - meanImage*ones(1,numTestImage))';
Projected_Test = img*C;
%% ########################################################################


%% ################# Calculation of Distance from Neutral ##################
meanNutral = mean(S(NeutralImages,EigenRange)',2);
for Dat2Project = 1:numTestImage
    TestImage = Projected_Test(Dat2Project,:);
    % Picking the image #Dat2Project
 
    Eucl_Dist(Dat2Project) = sqrt((TestImage'-meanNutral)'*(TestImage' ...
        -meanNutral));
        % Here, the distance between the expression under test and
        % the mean neutral expressions is being calculated
end
%Eucl_Dist = Eucl_Dist/max(Eucl_Dist);
%% ########################################################################

%% ################# Calculation of other Distances #######################
Other_Dist = zeros(numTestImage,numImage);
for Dat2Project = 1:numTestImage
    TestImage = Projected_Test(Dat2Project,:);
    % Picking the image #Dat2Project
    for i = 1:numImage
        Other_Dist(Dat2Project,i) = sqrt((TestImage'-S(i,EigenRange)')' ...
            *(TestImage'-S(i,EigenRange)'));
    end
end
[Min_Dist,Min_Dist_pos] = min(Other_Dist,[],2);
%% ########################################################################


%% ########################## Display Result ##############################
fid = fopen('Results.txt','w');
fprintf(fid,'//Test Image,Distance From Neutral, Expression,Best Match\r\n');

for i = 1:numTestImage
    b = find(TestImages{i,1}=='\');
    Test_Image = TestImages{i,1}(b(end)+1:end);
    Dist_frm_Neutral = Eucl_Dist(i);
    Best_Match = cell2mat(imageLabel{1,1}(Min_Dist_pos(i)));
    Expr = cell2mat(imageLabel{1,2}(Min_Dist_pos(i)));
    fprintf(fid,'%s,%0.0f,%s,%s\r\n',Test_Image,Dist_frm_Neutral,Expr,Best_Match);
end
fclose(fid);
%% ########################################################################
isSucceed = 1;
disp('Done')
disp('Output File = .\Results.txt');
Willexit = input('Press Enter to Quit ...','s');
end