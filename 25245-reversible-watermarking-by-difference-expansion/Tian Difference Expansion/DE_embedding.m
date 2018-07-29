% Implementation of 
% J. Tian, "Reversible Watermarking by Difference Expansion", ACM Multimedia and Security 
% Workshop, December 2002. (Implemented this paper)
% 
% J. Tian, “Reversible Data Embedding Using a Difference Expansion”, IEEE Transactions on 
% Circuits and Systems for Video Technology, vol.13, no.8, Aug 2003,
% pp.890 -896. 

% Date: 15-19, December, 2008
% By: Asad (asad_82@yahoo.com)

% NOTE: Change the value of T and NO_TIMES_EMBEDD to achieve more bpp.
% Lower value of T results in better PSNR but less embedding which can be
% compensated by increasing the value of NO_TIMES_EMBEDD variable to
% perform embedding as many times as you like.
% Also in case of error change the value of T(increase/decrease) as embedding may not be
% possbile using that value of T.

clear all;
close all;

%% DEFINE CONSTANTS
EMBED_DIRECTION = 1; % Value when set to 1 means horizontal direction embedding else vertical embedding
T = 20; % specifies the embedding threshold
NO_TIMES_EMBEDD = 2; % controls number of iteration of loop for embedding in different directions

%% STEP 1: Read the input image 
originalImage = imresize(imread('boat.tif'),[256 256],'bicubic');
if (isrgb(originalImage))
    originalImage = rgb2gray(originalImage);
end

%% STEP 2A: Loop for embedding in horizontal or vertical direction
markedImage = originalImage;
TOTAL_WM_LEN = 0;
for k=1:NO_TIMES_EMBEDD
   str = sprintf('Iteration # %d',k);
   disp(str);
   disp('--------------------')
   [markedImage,WM_LEN] = DE_Algorithm(markedImage,T,EMBED_DIRECTION);
   if EMBED_DIRECTION == 0
       EMBED_DIRECTION = 1;
   else
       EMBED_DIRECTION = 0;
   end
   TOTAL_WM_LEN = TOTAL_WM_LEN + WM_LEN;
end

%% Compute Total Payload & PSNR
disp('----------------------------------------------------------------');
str = sprintf('Payload(bpp) = %f ----- Total bits = %d',TOTAL_WM_LEN/(size(originalImage,1)*size(originalImage,2)),TOTAL_WM_LEN);
disp(str);

[PSNR_OUT,Z] = psnr(originalImage,markedImage);
str = sprintf('Final PSNR = %f',PSNR_OUT);
disp(str);

imwrite(uint8(markedImage),'WatermarkedImage.tif','tif');
figure,imshow(markedImage,[]),title('Watermarked Image')
