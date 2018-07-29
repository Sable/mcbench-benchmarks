function downloadkodakgallery(url,folder)
%DOWNLOADKODAKGALLERY
%   DOWNLOADKODAKGALLERY(URL,FOLDER) downloads all the pictures indexed on
%   the slideshow at the given URL.
%    
%   To use, navigate with your browser to the slideshow you want to
%   download.  That's the URL you want to use.
%    
%   Author: Matthew Simoneau
%   Date: October 8, 2005

% Make the folder if it doesn't exist.
if isempty(dir(folder))
    mkdir(folder)
end

% Download the HTML.
c = urlread(url);

% Read the HTML from a file.
% f = fopen('Slideshow.jsp.htm');
% c = native2unicode(fread(f,'uint8=>uint8')');
% fclose(f);

% Pick the images out of the HTML.
imageList = regexp(c,'(http://images.kodakgallery.com/servlet/Images/.*?\.jpg)','tokens');

% Download each image.
for iImageList = 1:length(imageList)
    imageUrl = imageList{iImageList}{1};
    imageFilename = fullfile(folder,sprintf('%02.0f.jpg',iImageList));
    disp(urlwrite(imageUrl,imageFilename));
end
