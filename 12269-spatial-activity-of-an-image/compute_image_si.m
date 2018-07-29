function SI = compute_image_si(filename_image,border_cut)
% SI = compute_image_si(filename_image,border_cut)
% 
%  This is the measure of ITU-T P.910 spatial on single images
%  (see pages 12, 15, 22-24)
%
%  border_cut pixels are removed from each side of the image before
%  computation. Default setting is 0
%
%  edited for single images by Bjoern Eskofier, 03/01/06


% default for border_cut
if (nargin == 1)
    border_cut = 0;
end

% load the image to compute
rgb_values = imread(filename_image);

% check
if (size(rgb_values,1) < border_cut*2+1 || size(rgb_values,2) < border_cut*2+1)
    error('image size and/or border_cut not sensible. Please check')
end

% cut the image - remove border_cut pixels on each side
rgb_values = rgb_values(border_cut+1:end-border_cut,border_cut+1:end-border_cut,:);

% compute the y plane
ycbcr_values = rgb2ycbcr(rgb_values);
y_values = ycbcr_values(:,:,1);

% define the Sobel filter matrices
v_matrix = [ -1, 0, 1; -2, 0, 2; -1, 0, 1];
h_matrix = [ -1, -2, -1; 0, 0, 0; 1, 2, 1];

% some numbers
x_size = size(rgb_values,2);
y_size = size(rgb_values,1);
frame_size = y_size*x_size;

% time measurement
%tic

% filtering
gv_full = filter2(v_matrix,y_values);
gv = gv_full(2:(end-1),2:(end-1));
%figure
%imagesc(gv)
gh_full = filter2(h_matrix,y_values);
gh = gh_full(2:(end-1),2:(end-1));
%figure
%imagesc(gh)

% integration of horizontal and vertical image
y = sqrt(gv.^2+gh.^2);
% figure
% imagesc(y)
% title(num2str(std2(y)))

% std dev calculation
sigma = std2(y);

% SI output
SI = max(sigma);

% end of time measurement
%toc