function [I,p] = LEMS1im_crop(p)
% LEMS1im_read: Read one image for LEMS correction
%
% [I,p] = LEMS1im_read()
% I: selected image
% p: parameters
%         info: 'N/A'   % 'N/A' if not dicom
%         Imin: 2       % for contrast
%         Imax: 255
%         rect: [10.2942 13.0805 113.4776 118.8813] % for croping I0
%     filename: 'arlie.pd.im256gl4.tif' % I0 location 
%     pathname: [1x64 char]
%
% Olivier Salvado, Case, 15-nov-06
% v0: from stepA_1 in LEMS 2D pipeline

disp(' ')
disp([' --- crop image for LEMS1im...'])
% warning off MATLAB:divideByZero

%% read original file
try 
    % --- try to read a Dicom
    info = dicominfo([p.filepath p.filename]);
    I0 = dicomread([p.filepath p.filename]);
catch
    % --- if there is an error, it must be an image.
    info = 'N/A';
    I0 = imread([p.filepath p.filename]);
end


%% check if it is a rgb image
if size(I0,3)>1,
    disp('This image has multiple channels, try to convert to gray')
    I0 = rgb2gray(I0);
end

%% window
I0 = single(I0)-p.Imin;
I0 = I0/(p.Imax-p.Imin)*255;

%% ask for cropping
imshow(uint8(I0))
[I,rect] = imcrop;
I = imcrop(I0,rect);
im(I)

%% update the outputs
p.rect = rect;
disp('     ... Data loaded')

