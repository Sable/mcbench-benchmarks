function hsvAll = getHSVColorFromDirectory(dirName)

%
% function hsvAll = getHSVColorFromDirectory(dirName)
%
% This function is used for "training" the color detection model.
%
% ARGUMENTS:
% dirName: the name of the directory in which the images are stored.
%
% RETURN VALUE:
% hsvAll: this Mx3 matrix, in each row contains the average hsv value of
% of the respective image (of dirName dir).
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Theodoros Giannakopoulos - January 2008
% www.di.uoa.gr/~tyiannak
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


D = dir(dirName);
length(D)
hsvAll = [];

for (i=3:length(D)) % for each file in the directory:
    if (strcmpi(D(i).name(end-3:end), '.jpg')==1) % if current file IS JPG:        
        RGB = imread([dirName '/' D(i).name]);        
        HSV = selectPixelsAndGetHSV(RGB, 5);
        hsvAll = [hsvAll;HSV];
    end
end
