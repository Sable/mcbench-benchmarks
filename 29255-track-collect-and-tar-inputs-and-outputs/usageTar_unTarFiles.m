%clear all;
% tarFileType = '.zip'; % 1 file extension
tarFileType = '.tar.gz'; % 2 file extensions
tarFileName = 'resultsPackaged';
tarFile = strcat(tarFileName, tarFileType);
secondsMode = {'sec_ON', 'msec_ON', 'sec_OFF'};
secondsMode = char(secondsMode(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% timestamp the file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fileTimeStamped = timeStampedFile( file );
numberOfFileExtensions = length(strfind(tarFileType, '.'));
tarFile = timeStampedFile( tarFile, numberOfFileExtensions, secondsMode ); % timestamp the file
tarFile = char(tarFile);

% images in this instance
% point to folder [INPUT]
fileTypes = {'*.jpg', '*.txt'};
contentsInInputFolder = strcat(inputFilesFolder, '\', fileTypes);
contentsInInputFolder2 = strcat(inputFilesFolder, '\', subFolderForImages, '\', fileTypes);
%contentsInInputFolder = inputTreeProfile.name;

% point to folder 2
contentsInOutputFolder = strcat(outputFilesFolder, '\', fileTypes);
contentsInOutputFolder2 = strcat(outputFilesFolder, '\', subFolderForImages, '\', fileTypes);
%contentsInOutputFolder = outputTreeProfile.name;

contentsToBeTarZipped = vertcat(contentsInInputFolder, contentsInOutputFolder);
contentsToBeTarZipped = vertcat(contentsToBeTarZipped, contentsInInputFolder2, contentsInOutputFolder2);

%contentsToBeTarZipped = [contentsInInputFolder, contentsInOutputFolder];

contentsToBeTarZipped = contentsToBeTarZipped(:)';
% contentsToBeTarZipped = sort(contentsToBeTarZipped);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tar pack the files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tar(tarFile, contentsToBeTarZipped); % max = 2 GB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract the zipped contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%folderToBeExtractedTo = 'viewTarContents';
%untar(tarFile, folderToBeExtractedTo);