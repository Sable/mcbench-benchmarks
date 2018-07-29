function [masked_image] = separate(working_image,background_dominant)
%Seperate function: Using a sum-of-gaussians model (2 gaussians) for the color at each pixel results in a simple way of seperating the background.
%Written by Alexander Farley, April 19 2011
%alexander.farley at utoronto.ca
%Updated October 8 2011: Added a flag for pictures where the foreground is dominant
%
%
%working_image: the input image to be counted
%background_dominant: set to 1 if the background occupies more than 50% of
%the image area, otherwise set to 0
%masked_image: binary background/cell separated image

[image_height image_width num_colors] = size(working_image);

%Seperate into color columns
Acolumn = working_image(:,:,1);
Bcolumn = working_image(:,:,2);
Ccolumn = working_image(:,:,3);

%Show original color data in 3D space
% figure
 Areduced = downsample(Acolumn(:),1000);
 Breduced = downsample(Bcolumn(:),1000);
 Creduced = downsample(Ccolumn(:),1000);
% scatter3(Areduced, Breduced, Creduced);

%Combine columns
sample_data = [Acolumn(:)'; Bcolumn(:)'; Ccolumn(:)';];
sample_data_reduced = [Areduced(:)'; Breduced(:)'; Creduced(:)'];

[W,M,V,L] = EM_GM(sample_data_reduced', 2);

%Calculate pdf using Gaussian parameters estimated using EM
membership = zeros(length(Acolumn(:)), 2);
for j=1:length(Acolumn(:))
    membership(j,1) = W(1)*mvnpdf(sample_data(:,j), M(:,1), V(:,:,1));
    membership(j,2) = W(2)*mvnpdf(sample_data(:,j), M(:,2), V(:,:,2));
end

is_bg = membership(:,2) > membership(:,1);
bg_mask = reshape(is_bg, image_height,image_width);
if background_dominant
if W(1) > W(2)
fg_mask = bg_mask;
else
    fg_mask = ~bg_mask;
end
else
if W(1) > W(2)
fg_mask = ~bg_mask;
else
    fg_mask = bg_mask;
end  
end

masked_image = working_image;
masked_image(:,:,1) = fg_mask.*masked_image(:,:,1);
masked_image(:,:,2) = fg_mask.*masked_image(:,:,2);
masked_image(:,:,3) = fg_mask.*masked_image(:,:,3);

masked_image = masked_image > 1;



