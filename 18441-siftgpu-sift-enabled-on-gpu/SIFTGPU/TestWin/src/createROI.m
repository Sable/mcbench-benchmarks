function createROI(imagename)
%
% createROI(imagename) makes a grayscale version of the input image name 'imagename' 
% with limited intensities and saves it in the current directory. Interesting
% regions in the image should then be painted over in white using windows
% paint.
%
% Example: createROI('cameraman.jpg') will create a new image named
%         'cameramanROI.tif' which should then have its ROI highlighted with white 
%         in windows paint.

im=imread(imagename);

if size(im,3)==3
    im=rgb2gray(im);
end

im=im*0.9;
imshow(im);
ROIname=[imagename(1:length(imagename)-4) 'ROI.tif'];
filename=[pwd '\' ROIname]
imwrite(im,filename);

disp(['An image named ' ROIname ' is now saved in the folder ' pwd '.'])
disp('open windows paint and paint over the region of interest in white, then save the image under its current ')
disp('name in its current directory')