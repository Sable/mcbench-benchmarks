clear all; close all; clc;
newlineInAscii1 = [13 10];
spaceInInAscii = 32;
% for printing, newline causes much confusion in matlab and is provided here as an alternative
newline = char(newlineInAscii1); 
spaceChar = char(spaceInInAscii);

inputFilesFolder = 'inputFiles';
outputFilesFolder = 'outputFiles';
subFolderForImages = 'images';

% inputTreeProfile = folderSizeTree(inputFilesFolder);
% outputTreeProfile = folderSizeTree(outputFilesFolder);

% prepare output site
mkdir(outputFilesFolder);
mkdir(strcat(outputFilesFolder, '\', subFolderForImages));

targetFile = '';

processStatus = [datestr(now), ' >> ', 'OFF'];

% demo saving images
usage_savefigs;

% demo reading string files (not using textread, example only)
usage_readWriteStringsToFile;

% collect statuses along the way
processStatus = [processStatus, newline, ...
                     datestr(now), ' >> ', 'ALL PROCESSES DONE.'];
         
targetFile = 'statusTrack.txt';
targetFile = strcat(outputFilesFolder, '\', targetFile);                 
% write staus to file
fid = fopen(targetFile, 'w');
fwrite(fid, processStatus, '*char');
fclose(fid);

% tar the input and output file folders with contents
usageTar_unTarFiles;

%{
Objective: Demonstrates collection of inputs and direction of outputs for archival
SubObjective: 
       - status tracking
       - for printing, newline causes much confusion in matlab and a short implementation is provided here as an alternative

%}