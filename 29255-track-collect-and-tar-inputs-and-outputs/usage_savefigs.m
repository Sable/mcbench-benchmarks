% close all; clc;
processStatus = [processStatus, newline, ...
                     datestr(now), ' >> ', '[Start image outputing].'];

processStatus = [processStatus, newline, ...
                     datestr(now), ' >> ', 'Plotting graphs ...'];
                  
% plotting processes
x = -pi:0.01:pi;
figure(1)
plot(x,sin(x)), grid on
figure(2)
plot(x,sin(x)), axis off;

processStatus = [processStatus, newline, ...
                     datestr(now), ' >> ', 'Writing images ...'];
 
% input image to be read
targetFile = 'mri.jpg';
targetFile = strcat(inputFilesFolder, '\', subFolderForImages, '\', targetFile);

img = imread(targetFile);
figureIndex = 10;
figureTitle = ['img']; 

% figure(figureIndex), 
figure('Name', figureTitle,'NumberTitle','off'),
imshow(img,[]);
pause(1);
%close all;

imageResultRepository = strcat(outputFilesFolder, '\', subFolderForImages);

imageFileType = '.jpg';
% do not close images before savefigs
savefigs(imageResultRepository, imageFileType);
close all;

processStatus = [processStatus, newline, ...
                     datestr(now), ' >> ', '[END image outputing].'];
