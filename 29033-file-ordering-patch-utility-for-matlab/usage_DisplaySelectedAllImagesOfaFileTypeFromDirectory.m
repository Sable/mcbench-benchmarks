clc;
clear all;

targetFolder = 'repositoryArchive';
imageFileType = '.jpg';

[imageFiles, imageFileCount] = listFilesInDirectory( targetFolder, imageFileType );
% imageFiles = char(imageFiles)
imageFiles = resortFileOrder(imageFiles);
imageFiles = cellstr(imageFiles);

%%%%%%%%%%%%%%%%%%%%%%%%
displayImagesInDirectory(targetFolder, imageFiles, imageFileCount, imageFileType);