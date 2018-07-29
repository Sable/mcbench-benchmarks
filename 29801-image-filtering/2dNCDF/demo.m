
% =======================================================================
%     Improved adaptive complex diffusion despeckling filter (NCDF)
% =======================================================================
% DESCRIPTION: Demo for despeckling filter
%
% _________________________________________________________________________
% REFERENCES:
% [1] Rui Bernardes, Cristina Maduro, Pedro Serranho, Adérito Araújo,
%     Sílvia Barbeiro, and José Cunha-Vaz,
%     "Improved adaptive complex diffusion despeckling filter,"
%     Opt. Express 18, 24048-24059 (2010).
% 
% Work developed under the research project supported by Fundação para a
% Ciência e a Tecnologia (FCT): PTDC/SAU-BEB/103151/2008 and program 
% COMPETE (FCOMP-01-0124-FEDER-010930)
%
% http://www.opticsinfobase.org/oe/abstract.cfm?URI=oe-18-23-24048
% http://www.aibili.pt
%
%
% DEPENDENCIES:
% needs the matlab image processing toolbox
% _________________________________________________________________________
%
%
% 
% AIBILI - Association for Innovation and Biomedical Research on Light and
% Image


% Demo
clear all;
close all;


% diffusion time in seconds
TMAX         = .80; 

% display parameters
minIntensity = 0;
maxIntensity = 220;
iRoi         = [250  750     250    500];



% read an image
Img_noisy    = imread('img.jpg');

% Apply filter to reduce the speckle noise
[Img_filtered, nIter, dTT] = twodncdf(Img_noisy, TMAX);



% DISPLAY results
figure(1),
imagesc(Img_noisy),    title('original image');
caxis([minIntensity maxIntensity]), axis off, colormap(gray)
rect=[iRoi(3) iRoi(1) iRoi(4)-iRoi(3) iRoi(2)-iRoi(1)];
rectangle('Position',rect,'EdgeColor','y','LineStyle','--','Linewidth',2)



figure(2),
imagesc(Img_noisy),    title('original image');
caxis([minIntensity maxIntensity]), axis off, colormap(hsv)
axis(iRoi([3 4 1 2]))

figure(3),
imagesc(Img_filtered), title('filtered image');
caxis([minIntensity maxIntensity]), axis off, colormap(hsv)
axis(iRoi([3 4 1 2]))


