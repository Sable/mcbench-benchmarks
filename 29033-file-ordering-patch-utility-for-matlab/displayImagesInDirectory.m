function displayImagesInDirectory(targetFolder, imageFiles, imageFileCount, imageFileType)
%DISPLAYIMAGESINDIRECTORY 

numberOfImages = imageFileCount;
pattern_fileType = imageFileType;

numberOfPlotsPerRow = ceil(sqrt(numberOfImages));
numberOfPlotsPerColumn = numberOfPlotsPerRow;
plotIndex = 1;

figureTitle = ['Images In Repository']; 
figure('Name', figureTitle,'NumberTitle','off'),

for i = 1:numberOfImages
    imageChoiceIndex = i;

    targetImage = cell2str(imageFiles(imageChoiceIndex));
    % remove '{' and '}'
    targetImage = regexprep(targetImage, '{', '');
    targetImage = regexprep(targetImage, '}', '');
    targetImage = regexprep(targetImage,'''', ''); % remove character '
          
    redirectedPath = strcat(targetFolder);                        
    imageToBeDisplayed = strcat('.\',redirectedPath, '\', targetImage);                    
    
    imageToBeDisplayed = imread(imageToBeDisplayed);
    
    sizeOfImage = size(imageToBeDisplayed);

    subplot(numberOfPlotsPerRow,numberOfPlotsPerColumn,plotIndex),
    imshow( imageToBeDisplayed, [] ); title( sprintf( '%s size: %s',targetImage, num2str(sizeOfImage)) );
    plotIndex = plotIndex + 1;
    hold on;    
end   

end

