% This function demonstrates the usage of the image cube slicer by 
% Timo Eckhard - timo.eckhard(at)gmx.com.
%
% Please do not hesitate to contact me with any questions about the usage,
% reports about bugs or feature requests for new versions.
%
% To attribute the authors work, please reference the original files in
% derivative works!
%
% NOTE: the im_cube_slicer is only tested with Matlab > R2011a. Problems
%       have been reported for R2010!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load a demo image
im = imread('cameraman.tif');


%% make it multi-channel
%(this is NOT a multispectral image, but a simple way to demonstrate the 
% usgage of the function! Do not get irritated if the spectral view 
% does not make sense! In here, a sample image is just rotated differntly 
% in each image plane.)
im_multi  = zeros(size(im,1),size(im,2),20);
for i=1:1:20
    im_multi(:,:,i) = imrotate(im,360/20*(20-i+1),'bicubic','crop');
end


%% show the NORMALIZED image cube in imshow() mode -> method = 'fixed'
im_norm = im_multi./255;              	%normalize image
lambda = 1:1:size(im_multi,3);          %simply use a vector 1:1:num_bands
s_factor = 1;                           %we use only every 2nd pixel the make the image smaller
fh = im_cube_slicer(im_norm,lambda,s_factor,'fixed');
waitfor(fh);                               %wait until the figure is closed


%% show the NOT NORMALIZED image cube in imscale() mode -> method = 'scaled'
lambda = 1:1:size(im_multi,3);          %simply use a vector 1:1:num_bands
s_factor = 1;                           %we DO NOT scale the image size
fh = im_cube_slicer(im_multi,lambda,s_factor,'scaled');
waitfor(fh);                            %wait until the figure is closed



