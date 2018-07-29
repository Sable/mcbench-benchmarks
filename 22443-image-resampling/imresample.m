function nimg = imresample(oldpixsize,img,newpixsize,intmethod)
% nimg = imresample(oldpixsize,img,newpixsize,intmethod)
% This function resamples the images at the new grid points
% defined by the new pixel sizes. It assumes that intensities are
% defined at the pixel centers
%
%    img  : original image to be resampled
%    nimg : newly sampled image
%    oldpixsize : a vector of the form [xpixsize ypixsize] 
%       for the original image, e.g., [0.5,0.5]
%    newpixsize : is a vector of the form [xpixsize ypixsize]
%       for the new image, e.g., [0.2,0.2]
%    intmethod: same as interp2
%       'nearest' - nearest neighbor
%       'linear'  - bilinear
%       'cubic'   - bicubic
%       'spline'  - spline
%
% Example:
% 
% % Create a 2D gaussian function
% H = fspecial('gaussian',[31,31],5);
% Resample it at a smaller pixel size
% NH = imresample([1,1],H,[0.2,0.2],'spline');
% figure;subplot(211);imshow(H,[]);title('Original'); 
% subplot(212);imshow(NH,[]);
% title('Resampled using spline interplolation');

% Omer Demirkaya 12/14/2008

% Find the dimesions of the image
[r,c,z] = size(img);
r = r-1;
c = c-1;
% smaller variable names
ops = oldpixsize;
nps = newpixsize;
ss  = ops/2;
nn  = nps/2;
% create the meshes for old and new image
[Ox,Oy] = meshgrid(ss(1):ops(1):c*ops(1)+ss(1),...
    ss(2):ops(2):r*ops(2)+ss(2));

[Nx,Ny] = meshgrid(nn(1):nps(1):c*ops(1)+nn(1),...
    nn(2):nps(2):r*ops(2)+nn(2));

% create the new image z > 1 for multispectral images (e.g. z = 3 RGB color images)
for i=1:z
    nimg(:,:,i) = interp2(Ox,Oy,img(:,:,i),Nx,Ny,intmethod);
end