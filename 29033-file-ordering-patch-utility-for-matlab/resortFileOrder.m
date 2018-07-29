function fileList = resortFileOrder(fileList)
% this patches the file ordering for matlab, ie. to take into account the re-sorting of length wise as well
% fileList = char(fileList);

sortedT = sort(fileList);

for i = 1:length(sortedT)
   lengthOfEachString(i) = length(char(sortedT(i))) ; 
end

sortByLength = sort(lengthOfEachString);

% remove repeated numbers
arrayOfIndices = sortByLength;
uniqueNumbers = unique(arrayOfIndices);
sortByLength = uniqueNumbers;

numberOfGroups = length(sortByLength);

for i = 1:numberOfGroups
   indexToCheckFor = find(sortByLength(i) == lengthOfEachString);
   sortedWithLengthTakenCare{i} = char(sortedT(indexToCheckFor)); 
end

sortedIndex = [];
% append the clustered list
for i = 1:numberOfGroups
   % fprintf('%s \n', sortedWithLengthTakenCare{i}); 
   
   numberOfItemPerCluster = size(sortedWithLengthTakenCare{i}, 1);
   
   clusterToBeAddressed = cellstr(sortedWithLengthTakenCare{i});
   
   for j=1:numberOfItemPerCluster
       sortedIndex = [sortedIndex, '', clusterToBeAddressed(j)];
   end
   % sortedIndex = [sortedIndex sortedWithLengthTakenCare{i}];
end

fileList = char(sortedIndex);

end


%{
clc;
clear all;

targetFolder = 'repositoryArchive';
imageFileType = '.jpg';

[imageFileNames, imageFileCount] = listFilesInDirectory( targetFolder, imageFileType );

for i = 1:imageFileCount
    imageChoiceIndex = i;
    imageFileAddressed = cell2str(imageFileNames(imageChoiceIndex));
    % remove '{' and '}'
    imageFileAddressed = regexprep(imageFileAddressed, '{', '');
    imageFileAddressed = regexprep(imageFileAddressed, '}', '');
    imageFileAddressed = regexprep(imageFileAddressed,'''', ''); % remove character '
    
    numberIndex(i) = str2num(extractNumberIndexFromFileName(imageFileAddressed));
end

sortedFileOrder = sort(numberIndex, 'ascend');

% depicts the file picked in order

for i = 1:imageFileCount
    addressedFile(i) = find (sortedFileOrder(i) == numberIndex);
end
%}