%% ITERATIVE FEATURES MATCHING
%% The function select certain number of stereo features.
%% The quality of the selected features is given by the parameter SIGMA_MAX, 
%% which represent the variance of the position estimate error. 
%% Higher values of SIGMA_MAX to selecti more features, lower values for less features. 

%% Lorenzo Sorgi
%% Virtual Reality lab
%% Italian Aerospace Research Centre
%% l.sorgi@cira.it


function [x1,x2,corr_vec]=features_matching(im1, im2, cal, initsplit, sm_sigma, sigma_max)
% Input
% im1, im2  : stereo pair. grayscale images 
% cal       : (1=rectified images with epipolar horizontal lines; 0=uncalibrated images )
% initsplit : images initial splitting factor; the images are splitted in (initsplit x initsplit) subimages. 
% sm_sigma  : smoothing gaussian filter SD (1 -:- 3 for normal smoothing)
% sigma_max : Fisher index th (1e-2 -:- 1e-4)

%% Output
%% x1, x2   : matched points in the left and right images; 2 x N matrices 
%%            x1=[u1 u2 ....uN       horiz. coord.
%%                v1 v2 ....vN]      vert. coord.
%% corr_vec : match strngth


%% IMAGE PREPROCESSING
if length(size(im1))==3
    disp('images converted to grayscale')
    im1=rgb2gray(im1);
    im2=rgb2gray(im2);
end

g = fspecial('gaussian',max(1,fix(6*sm_sigma)), sm_sigma);
im1 = conv2(im1, g, 'same'); 
im2 = conv2(im2, g, 'same'); 


%% GLOBAL VARIABLES
global IM1 IM2 IM1_X IM1_Y IM1_X2 IM1_Y2 SIGMA_MAX
IM1 = im1; IM2 = im2;
[IM1_X, IM1_Y]=gradient(IM1);
IM1_X2=IM1_X.^2;    IM1_Y2=IM1_Y.^2;
SIGMA_MAX=sigma_max;

%% MATCHING PARAMETRS 
th=0.2;                        % matching threshold
split_off=5;                   % sub-images overlapping region
matched_points=[];             % correspondences matrix
[sy,sx]=size(im1);             % images dimension
sub_im_size=[sy,sx]/initsplit; % sub-images dimension
im1=double(im1);
im2=double(im2);
in_weigth=0;                    %initial matching score


% FEATURES MATCHING
for split_y_in=0:(initsplit-1)
    for split_x_in=0:(initsplit-1)
        
        d_upl_1=floor( sub_im_size.*[split_y_in,split_x_in] - [split_off,split_off].*[split_y_in>0,split_x_in>0] );
        upl_1=[1,1]+d_upl_1; 
        
        d_upl_2=floor( sub_im_size.*[split_y_in,split_x_in] - [split_off,split_off].*[split_y_in>0,split_x_in>0] );
        upl_2=[1,1]+d_upl_2;
        
        d_lor_1=floor( sub_im_size.*[initsplit-1-split_y_in,initsplit-1-split_x_in] - [split_off,split_off].*[(initsplit-1-split_y_in)>0,(initsplit-1-split_x_in)>0] );
        lor_1=[sy,sx]-d_lor_1;
        
        d_lor_2=floor( sub_im_size.*[initsplit-1-split_y_in,initsplit-1-split_x_in] - [split_off,split_off].*[(initsplit-1-split_y_in)>0,(initsplit-1-split_x_in)>0] );
        lor_2=[sy,sx]-d_lor_2;
        
        sub_im1=im1(upl_1(1):lor_1(1),upl_1(2):lor_1(2));
        sub_im2=im2(upl_2(1):lor_2(1),upl_2(2):lor_2(2));
        
        matched_points=[matched_points;
                        it_features_matching(upl_1, lor_1, upl_2, lor_2, th, cal, [], in_weigth) ];
    end
end

npts=size(matched_points,1);
if npts>0
    % ordering in match weigth desending order
    matched_points = sortrows(matched_points,5);     
    matchd_points = flipdim(matched_points,1);       
    matched_points=matched_points';
    
    x1=matched_points(1:2,:);     x1=flipdim(x1,1);
    x2=matched_points(3:4,:);     x2=flipdim(x2,1);
    corr_vec=matched_points(5,:);
else error('No feature selected. raise the SIGMA_MAX parameter.')
end
disp([int2str(npts) 'features selcted. For more features use higher value of SIGMA_MAX.']);

