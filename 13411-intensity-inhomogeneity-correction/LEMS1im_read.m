function [I,p] = LEMS1im_read()
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
disp([' --- Read one image for LEMS1im...'])
% colormap(gray(256)),clf
% set(gcf,'BackingStore','on')
% debug = 0;
% warning off MATLAB:divideByZero

%% ask for the file
wiam = cd;
% cd('C:\Documents and Settings\oxs13\My Documents\0 Main backup\Matlab Codes\Data for experiment')
cd('C:\')
[filename, filepath] = uigetfile('*.*', 'Select image to correct');
cd(wiam);
disp(['     In folder:' filepath])

%% read the file
try 
    % --- try to read a Dicom
    info = dicominfo([filepath filename]);
    I0 = dicomread([filepath filename]);
catch
    % --- if there is an error, it must be an image.
    info = 'N/A';
    I0 = imread([filepath filename]);
end

%% check if it is a rgb image
if size(I0,3)>1,
    disp('This image has multiple channels, try to convert to gray')
    I0 = rgb2gray(I0);
end

%% convert to [0...255]
I0 = single(I0);
Imin = min(I0(:));
Imax = max(I0(:));
I0 = I0-Imin;
I = I0/(Imax-Imin)*255;

%% update the outputs
p.info = info;
p.Imin = Imin;
p.Imax = Imax;
p.filename = filename;
p.filepath = filepath;

disp('     ... Data loaded')

