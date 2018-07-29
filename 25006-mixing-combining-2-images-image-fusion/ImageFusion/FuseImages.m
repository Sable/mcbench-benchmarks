%Program for Fusing 2 images

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

%Program Description
%This program is the main entry of the application.
%This program fuses/combines 2 images
%It supports both Gray & Color Images
%Alpha Factor can be varied to vary the proportion of mixing of each image.
%With Alpha Factor = 0.5, the two images mixed equally.
%With Alpha Facotr < 0.5, the contribution of background image will be more.
%With Alpha Facotr > 0.5, the contribution of foreground image will be more.

function fusedImg = FuseImages(bgImg, fgImg, alphaFactor)

bgImg = double(bgImg);
fgImg = double(fgImg);

fgImgAlpha = alphaFactor .* fgImg;
bgImgAlpha = (1 - alphaFactor) .* bgImg;

fusedImg = fgImgAlpha + bgImgAlpha;


