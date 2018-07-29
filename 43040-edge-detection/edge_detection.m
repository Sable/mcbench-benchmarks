function edge_detection(userImage)
% Clean up.
clc; % Clear the command window.
clear all;
close all; % Close all figures (except those of imtool.)
workspace;
fontSize = 20;
if nargin == 0
    % No image passed in on the command line.
    % Read in one of the standard MATLAB demo images
    % as our original gray scale image and display it.
   promptMessage = sprintf('Which image do you want to use');
    button = questdlg(promptMessage, 'Select Image', 'Coins', 'Cameraman','Coins');
     if strcmp(button, 'Coins')
        grayImage = double(imread('coins.png')); % Cast to double.
    else
        grayImage = double(imread('cameraman.tif')); % Cast to double.
    end
else
    % Use the image array passed in on the command line.
    grayImage = double(userImage); % Cast to double.
end
% Start timing.
startTime = tic;

subplot(2, 3, 1);
imshow(grayImage, []);
title('Original Image', 'FontSize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Blur the image with a 5 by 5 averaging (box filter) window.
blurredImage = conv2(grayImage, ones(5,5)/25);
subplot(2, 3, 2);
imshow(blurredImage, []);
title('Blurred Image', 'FontSize', fontSize);
% Perform a variance filter.
% Output image is the variance of the input image in a 3 by 3 sliding window.
VarianceFilterFunction = @(x) var(x(:));
varianceImage = nlfilter(grayImage, [3 3], VarianceFilterFunction);
% An alternate way of doing the variance filter is on the next line:
% varianceImage = reshape(std(im2col(originalImage,[3 3],'sliding')),
%size(Original Image-2);
subplot(2, 3, 3);
imshow(varianceImage, [])
title('Variance Image', 'FontSize', fontSize);

% Compute the square root of the variance image to get the standard deviation.
standardDeviationImage = sqrt(varianceImage);
subplot(2, 3, 4);
imshow(standardDeviationImage, [])
title('Standard Deviation Image', 'FontSize', fontSize);

% Compute the standard deviation filter with MATLAB's built-in stdfilt() filter.
standardDeviationImage2 = stdfilt(grayImage);
subplot(2, 3, 5);
imshow(standardDeviationImage2, [])
title('Built-in stdfilt() filter', 'FontSize', fontSize);

% Perform Sobel filter
% h = fspecial('sobel') returns a 3-by-3 filter h (shown below) thatemphasizes horizontal edges
% using the smoothing effect by approximating a vertical gradient.
% If you need to emphasize vertical edges, transpose the filter h'.
% [ 1 2 1
% 0 0 0
% -1 -2 -1 ]
verticalSobel = fspecial('sobel')';
sobelImage = imfilter(grayImage, verticalSobel);
subplot(2, 3, 6);
imshow(sobelImage, [])
title('Sobel edge filter', 'FontSize', fontSize);

verticalunsharp = fspecial('unsharp');
unsharpImage = imfilter(grayImage, verticalunsharp);
figure,imshow(unsharpImage, [])
title('unsharp image', 'FontSize', fontSize);



end

