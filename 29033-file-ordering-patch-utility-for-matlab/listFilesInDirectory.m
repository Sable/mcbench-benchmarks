function [ imageFiles, imageFileCount] = listFilesInDirectory( targetFolder, imageFileType )
%LISTFILESINDIRECTORY 

listing = dir(fullfile(pwd, targetFolder, ['*', imageFileType]));
imageFileCount = length(listing);
[imageFiles{1:imageFileCount}] = listing.name;
[~, lengthIndex] = sort(cellfun('length', imageFiles));
[imageFiles{1:imageFileCount}] = imageFiles{lengthIndex}; 

end

%{
% FootNotes
% =========
% Emended from suggestion by Donn Shull
% The above coding is equivalent in function and
% avoids loops and may be quicker for a large number of files: 

listing = dir(strcat('.\', targetFolder));
% listing = listing(find(~cellfun(@isempty,{listing(:).date})))

numberOfFiles = length(listing);
imageFileCount = 0;
imageFiles = [];

for i=1:numberOfFiles
    if (strfind(listing(i).name, imageFileType))
        imageFileCount = imageFileCount + 1;
        imageFiles = [imageFiles, ' ', listing(i).name];
    end
end

imageFiles = strsplit(' ', imageFiles);
imageFiles = imageFiles(2:end); % remove the 1st element (space char, which is not a file)
%}
