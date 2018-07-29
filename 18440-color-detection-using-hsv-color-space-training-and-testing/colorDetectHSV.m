function colorDetectHSV(fileName, hsvVal, tol)

%
% function colorDetectHSV(fileName, hsvVal, tol)
% 
% This function is used for detecting a specified hsv value in images.
% 
% ARGUMENTS:
% fileName: the name of the jpg file to be loaded
% hsvVal: 3x1 array containing the HSV values to be detected
% tol: 1x1 or 2x1 or 3x1 array containing the tolerance (i.e. the maximum
% distance - in each hsv coefficient - of each pixel from hsvVal).
% 
% Example:
% colorDetectHSV('train/face07.jpg', median(HSV), [0.05 0.05 0.1]);
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Theodoros Giannakopoulos - January 2008
% www.di.uoa.gr/~tyiannak
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


RGB = imread(fileName);

HSV = rgb2hsv(RGB);

% find the difference between required and real H value:
diffH = abs(HSV(:,:,1) - hsvVal(1));

[M,N,t] = size(RGB);
I1 = zeros(M,N); I2 = zeros(M,N); I3 = zeros(M,N);

T1 = tol(1);

I1( find(diffH < T1) ) = 1;

if (length(tol)>1)
    % find the difference between required and real S value:
    diffS = abs(HSV(:,:,2) - hsvVal(2));    
    T2 = tol(2);
    I2( find(diffS < T2) ) = 1;    
    if (length(tol)>2)
        % find the difference between required and real V value:
        difV = HSV(:,:,3) - hsvVal(3);    
        T3 = tol(3);
        I3( find(diffS < T3) ) = 1;
        I = I1.*I2.*I3;
    else
        I = I1.*I2;
    end
else
    I = I1;    
end

subplot(1,2,1),imshow(RGB); title('Original Image');
subplot(1,2,2),imshow(I,[]); title('Detected Areas');