function hsvMean = selectPixelsAndGetHSV(RGB, Area)

%
% function hsvMean = selectPixelsAndGetHSV(RGB, Area)
%
% Use this function in order to select multiple points from an image (use
% right click to stop process). The selected points are used to calculate
% the average HSV values.

% ARGUMENTS:
% RGB: the RGB image
% Area: the area size used to calulate the HSV values of each point
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Theodoros Giannakopoulos - January 2008
% www.di.uoa.gr/~tyiannak
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clf;
warning off;
imshow(RGB); hold on;
HSV = rgb2hsv(RGB);
HSV2 = HSV;
numOfSelectedPixels = 0;
right_not_pressed = 1;
BUTTON = 1;
while (BUTTON~=3)
    numOfSelectedPixels = numOfSelectedPixels + 1;
    [X,Y,BUTTON] = GINPUT(1);    
    
    hsvTemp2 = HSV(Y-(Area-1)/2:Y+(Area-1)/2, X-(Area-1)/2:X+(Area-1)/2, :);    
        
    HSV2(Y-round((Area-1)/2):Y+round((Area-1)/2), X-round((Area-1)/2):X+round((Area-1)/2), :) = 0;
    
    hsvTemp = zeros(3,1);
    [K,L,M] = size(hsvTemp2);
    for (i=1:K)
        for (j=1:L)
            hsvTemp(1) = hsvTemp(1) + hsvTemp2(i,j,1);
            hsvTemp(2) = hsvTemp(2) + hsvTemp2(i,j,2);
            hsvTemp(3) = hsvTemp(3) + hsvTemp2(i,j,3);
        end
    end
    
    hsvTemp = hsvTemp / (K*L);
    
    hsv(numOfSelectedPixels,:) = hsvTemp;
    hsvMean = median(hsv,1);
    
    line([X-(Area-1)/2 X+(Area-1)/2] , [Y-(Area-1)/2 Y-(Area-1)/2]);
    line([X+(Area-1)/2 X+(Area-1)/2] , [Y-(Area-1)/2 Y+(Area-1)/2]);
    line([X+(Area-1)/2 X-(Area-1)/2] , [Y+(Area-1)/2 Y+(Area-1)/2]);
    line([X-(Area-1)/2 X-(Area-1)/2] , [Y+(Area-1)/2 Y-(Area-1)/2]);
    
    
    %rgbTemp = hsv2rgb(hsvTemp);
    %fprintf('Cur RGV Values:  %.3f %.3f %.3f\n', rgbTemp(1), rgbTemp(2), rgbTemp(3));
    %fprintf('Cur HSV Values:  %.3f %.3f %.3f\n', hsvTemp(1), hsvTemp(2), hsvTemp(3));
    %fprintf('Mean HSV Values: %.3f %.3f %.3f\n', hsvMean(1), hsvMean(2), hsvMean(3));
end

[N, t] = size(hsv);

% for (i=1:N) hsvM1(i) = median(hsv(1:i,1)); end    
% for (i=1:N) hsvM2(i) = median(hsv(1:i,2)); end    
% for (i=1:N) hsvM3(i) = median(hsv(1:i,3)); end    

hsvMean = median(hsv);

% figure;
% subplot(3,1,1); plot(hsvM1); title(sprintf('H-->%.4f',hsvM1(end)));
% subplot(3,1,2); plot(hsvM2); title(sprintf('S-->%.4f',hsvM2(end)));
% subplot(3,1,3); plot(hsvM3); title(sprintf('V-->%.4f',hsvM3(end)));
% 
% figure;
% RGB2 = hsv2rgb(HSV2);
% imshow(RGB2);