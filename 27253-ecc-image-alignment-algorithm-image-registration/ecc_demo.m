%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo execution of ECC image alignment algorithm
% 
% 13/5/2012, Georgios Evangelidis, georgios.evangelidis@inria.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% uncomment one of the four following lines
% transform = 'translation';
% transform = 'affine';
transform = 'homography';
%transform = 'euclidean';


%YOU MIGHT NEED MORE ITERATIONS FOR HOMOGRAPHIES!

NoI = 50; % number of iterations
NoL = 2;  % number of pyramid-levels

verbose = 1; %plot images at the end of execution

im_demo=imread('cameraman.tif'); % ... or try your image
%imwrite(im_demo,'image.pgm')

[A,B,C]=size(im_demo);

if C==3
    im_demo=rgb2gray(im_demo);
end

im_demo=double(im_demo);

switch lower(transform)
    case 'translation'
        % warp example for translation case
        warp_demo=[1.53;-2.67];
        
        warp_demo = warp_demo+20;
        
        init = [20;20];%translation initialization
                
    case 'affine'
        % warp example for affine case
        warp_demo=[1-0.02   .03      1.5;...
                    0.02   1-0.05   -2.5];
        
        warp_demo(1:2,3) = warp_demo(1:2,3)+20;
        init=[eye(2) 20*ones(2,1)];%translation-only initialization
        
    case 'euclidean'
        % warp example for euclidean case
        
        angle = pi/30;
        % BE CAREFUL WITH THE ANGLE SINCE THE ORIGIN IS AT THE TOP-LEFT OF THE
        % IMAGE AND LARGE ROTATIONS "PROJECT" POINTS OUTSIDE THE SUPPORT AREA
        
        warp_demo=[cos(angle) -sin(angle) 1.25;...
                   sin(angle) cos(angle) -2.55];
        
        warp_demo(1:2,3) = warp_demo(1:2,3)+20;
        
        init=[eye(2) 20*ones(2,1)];%translation-only initialization
        
    case 'homography'
        % warp example for homography case
        warp_demo=[1-0.02    -.03     1.5;...
                    0.05    1-0.05   -2.5;...
                   .0001    .0002      1];
        
        warp_demo(1:2,3) = warp_demo(1:2,3)+20;
        
        init=eye(3);
        init(1:2,3) = 20;%translation-only initialization
        
    otherwise
        error('ECC_DEMO: choose an appropriate transform string');
        
end

% ROI definition example (rectangular ROI)
Nx=1:B-40; % to avoid "projecting" points outside of support area
Ny=1:A-40;

% create a template artificially
template_demo = spatial_interp(im_demo, warp_demo, 'linear', transform, Nx, Ny);
%imwrite(uint8(template_demo),'template.pgm')

% ECC algorithm: The initialization here is just a translation
% by 20 pixels in both axes.  This rise to sufficient overlap. Otherwise,
% you can give as input image the image im_demo(21:end,21:end)
% without initialization, i.e. by ignoring the 6th input argument.

% This function does all the work
[results, final_warp, warped_image]=ecc(im_demo, template_demo, NoL, NoI, transform, init);
% [results, warped_image]=ecc(im_demo(21:end, 21:end, template_demo, NoL, NoI, transform);


nx = 1:size(template_demo,2);
ny = 1:size(template_demo,1);

image2 = spatial_interp(double(im_demo), final_warp, 'linear', transform, nx, ny);
template = double(template_demo);


%% display results
if verbose
    
    pad = 1; %pad=0 makes the ROI on the template to be hidden
    
    % project ROI corners by using the final warp
    ROI_corners=[nx(1)+pad nx(1)+pad nx(end)-pad nx(end)-pad;...
        ny(1)+pad ny(end)-pad ny(1)+pad ny(end)-pad];
    
    Mat=final_warp;
    
    if strcmp(transform,'translation')
        wROI_corners = ROI_corners + repmat(Mat,1,4);
        
    else
        
        wROI_corners=Mat*[ROI_corners;ones(1,4)];
        
        if strcmp(transform,'homography')
            wROI_corners=wROI_corners./repmat(wROI_corners(3,:),3,1);
        end
        
        
    end
    
    
    % plot images for high-resolution level of the pyramid (if any)
    subplot(2,2,1)
    imshow(uint8(template_demo))
    hold on
    line([nx(1)+pad nx(end)-pad],[ny(1)+pad ny(1)+pad],'Color','m')
    line([nx(end)-pad nx(end)-pad],[ny(1)+pad ny(end)-pad],'Color','m')
    line([nx(1)+pad nx(end)-pad],[ny(end)-pad ny(end)-pad],'Color','m')
    line([nx(1)+pad nx(1)+pad],[ny(1)+pad ny(end)-pad],'Color','m')
    hold off
    title('Template with marked ROI')
    axis on
    
    subplot(2,2,2)
    imshow(uint8(im_demo))
    hold on
    line([wROI_corners(1,1) wROI_corners(1,3)],[wROI_corners(2,1) wROI_corners(2,3)],'Color','m')
    line([wROI_corners(1,3) wROI_corners(1,4)],[wROI_corners(2,3) wROI_corners(2,4)],'Color','m')
    line([wROI_corners(1,2) wROI_corners(1,4)],[wROI_corners(2,2) wROI_corners(2,4)],'Color','m')
    line([wROI_corners(1,1) wROI_corners(1,2)],[wROI_corners(2,1) wROI_corners(2,2)],'Color','m')
    hold off
    title('Input image with warped ROI')
    axis on
    
    subplot(2,2,3)
    imshow(uint8(image2))
    title('Backward-warped input image')
    axis on
    
    % compute the error image
    image_error=double(image2)-template_demo;
    
    subplot(2,2,4)
    imshow(image_error,[])
    colorbar
    title('Error image')
    axis on
end




