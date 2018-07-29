%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function Developed by Fahd A. Abbasi.
% Department of Electrical and Electronics Engineering, University of
% Engineering and Technology, Taxila, PAKISTAN.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The function takes an image as an argument and returns an image as well.
% But the retunred image is the negative of the original image passed to
% the function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% USAGE (SAMPLE CODE)
%
%
%       pic = imread('cameraman.tif');
%       pic_neg = ait_imneg(pic);
%       imshow(pic);
%       figure,imshow(pic_neg); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   





function pic_negative = ait_imgneg(pic)

[x,y,z] = size(pic);
if(z==1)
    ;
else
    pic = rgb2gray(pic);
end

max_gray = max(max(pic));
max_gray = im2double(max_gray);
pic = im2double(pic);

for i = 1:x
    for j = 1:y
        pic_negative(i,j)= max_gray - pic(i,j);
        end
    end
end