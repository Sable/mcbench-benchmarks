%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo execution of ECC image alignment algorithm
% It shows results in the case of a partial overlap and shows
% how the algortihm refines the results of feature-based matching
%
%
% 20/2/2013, Georgios Evangelidis, georgios.evangelidis@inria.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

transform = 'homography';

NoI = 20; % number of iterations
NoL = 1;  % number of pyramid-levels

im_demo=imread('wallImage.png'); % ... or try your image

[A,B,C]=size(im_demo);

if C==3
    im_demo=rgb2gray(im_demo);
end
imu8 = im_demo;

im_demo=double(im_demo);

template_demo = imread('wallTemplate.png');
[A2, B2, C2] = size(template_demo);

if C2==3
    template_demo = rgb2gray(template_demo);
end
tempu8 = template_demo;
template_demo = double (template_demo);

%initialization by feature-based matching (use 1 iteration to see the
%initial registration)
    init = [0.7 -0.6 -34;
        0.7 0.8 -70;
        0.001 -0.001 1];

%call ECC
[results, final_warp, warped_image]=ecc(im_demo, template_demo, NoL, NoI, transform, init);
mask = spatial_interp(ones(A,B),final_warp, 'linear', transform, 1:B2, 1:A2);

figure; imshow(imu8);title('Input Image');
figure; imshow(tempu8); title('Template Image');
figure; imshow(uint8(warped_image)); title('Final Warped Image');

clear align1 align2;

% alignment based on initial warp
warped_init = spatial_interp(im_demo, init, 'linear', transform, 1:B2, 1:A2);
align1 = double(tempu8).*mask;
align1(:,:,2) = double(warped_init).*mask;
align1(:,:,3) = double(tempu8).*mask;
figure;imshow(uint8(align1)); title('Initial alignment');

% alignment based on final warp
align2 = align1;
align2(:,:,2) = double(warped_image).*mask;
figure;imshow(uint8(align2)); title('Final alignment');
