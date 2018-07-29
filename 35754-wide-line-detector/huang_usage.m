% Note: no im2double() used !
img = imread('finger.png'); % Read image

img = imresize(img,0.25);    % Downscale image

% Get the valid region, this is a binary mask which indicates the region of 
% the finger. For quick testing it is possible to use something like:
% fvr = ones(size(img));
% The lee_region() function can be found here:
% http://www.mathworks.com/matlabcentral/fileexchange/35752-finger-region-localisation
fvr = lee_region(im2double(img),4,20);    % Get finger region

%% Extract veins using wide line detector
r = 5; t=1; g=41; % Parameters
veins = huang_wide_line(img,fvr,r,t,g);

%% Visualise
rgb = zeros([size(img) 3]);
rgb(:,:,1) = im2double(img);
rgb(:,:,2) = im2double(img) + 0.2*double(veins);
rgb(:,:,3) = im2double(img);

figure;
subplot(2,1,1)
  imshow(img,[])
  title('Original image')
subplot(2,1,2)
  imshow(rgb)
  title('Wide line detector method')
