function imageData = readImage(fileTarget, numberOfFileExtensions)
%READIMAGE 
% numberOfFileExtensions = 1; % 2: eg. *.tar.gz
imageFileTypes = {'img', 'jpg'};

positionsOfDotsInStr = strfind(fileTarget, '.');
% for .tar.gz, it is 'end-1', else it is 'end'
offset = numberOfFileExtensions - 1;
if (length(positionsOfDotsInStr) ~= 0)
    fileName = fileTarget(1:(positionsOfDotsInStr(end-offset)-1));
    fileType = fileTarget((positionsOfDotsInStr(end-offset)+1):end);
end

if (strcmp(char(imageFileTypes(1)), lower(fileType)))
    N = 256;
    % read the image
    fid = fopen(fileTarget, 'rb');              
    imageData = fread(fid,[N,N]); 
    fclose(fid);      
    imageData = imageData';      
else
    % read image for JPG images
    imageData = imread (fileTarget);
    imageData = rgb2gray(imageData);    
end

end

