function [gray_enhanced]=gray_level_images(current_image);
 %% trying dc coefficients
[mrows,ncolumns]=size(current_image);
 current_image=mat2gray(current_image);
        H = fspecial('disk',10);
        gray_filtering=current_image;
        blurred_gray = imfilter(gray_filtering,H,'replicate');
        k=2;
    for i=1:1:mrows
        for j=1:1:ncolumns
gray_enhanced(i,j)=mat2gray((gray_filtering(i,j)+(k.*(gray_filtering(i,j)-blurred_gray(i,j)))));
        end
    end
%figure(10001);
imshow(gray_enhanced);