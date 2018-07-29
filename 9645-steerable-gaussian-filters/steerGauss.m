function [J,h] = steerGauss(I,arg1,arg2,arg3)

% STEERGAUSS Implements a steerable Gaussian filter.
%    This m-file can be used to evaluate the first
%    directional derivative of an image, using the
%    method outlined in:
%
%       W. T. Freeman and E. H. Adelson, "The Design
%       and Use of Steerable Filters", IEEE PAMI, 1991.
%
%    [J,H] = STEERGAUSE(I,THETA,SIGMA,VIS) evaluates
%    the directional derivative of the input image I,
%    oriented at THETA degrees with respect to the
%    image rows. The standard deviation of the Gaussian
%    kernel is given by SIGMA (assumed to be equal to
%    unity by default). The filter parameters are 
%    returned to the user in the structure H.
%
%    [J,H] = STEERGAUSE(I,H,VIS) evaluates the
%    directional derivative of the input image I, using
%    the previously computed filter stored in H. Note
%    that H is a structure, with the following fields:
%           H.g: 1D Gaussian
%          H.gp: first-derivative of 1D Gaussian
%       H.theta: orientation of filter
%       H.sigma: standard derivation of Gaussian
%
%    Note that the filter support is automatically
%    adjusted (depending on the value of SIGMA).
%
%    In general, the visualization can be enabled 
%    (or disabled) by setting VIS = TRUE (or FALSE).
%    By default, the visualization is disabled.
%
% Author: Douglas R. Lanman, Brown University, Jan. 2006.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part I: Assign algorithm parameters.

% Load default image (if none provided).
% Note: Converts to grayscale.
if ~exist('I','var') || isempty(I)
   I = imread('cameraman.gif');
end
I = mean(double(I),3);

% Process input arguments (according to usage mode).
if ~exist('arg1','var') || ~isstruct(arg1)
   
    % Usage: [J,H] = STEERGAUSE(I,THETA,SIGMA,VIS)
    usageMode = 1;
    
    % Assign default filter orientation (if not provided).
    if ~exist('arg1','var') || isempty(arg1)
      arg1 = 0;
    end
    theta = -arg1*(pi/180);

    % Assign default standard deviation (if not provided).
    if ~exist('arg2','var') || isempty(arg2)
       arg2 = 1;
    end
    sigma = arg2;
    
    % Assign default visualization state (if not provided).
    if ~exist('arg3','var') || isempty(arg3)
       arg3 = false;
    end
    vis = arg3;    
    
else
    
    % Usage: [J,H] = STEERGAUSE(I,H,VIS)
    usageMode = 2;
    
    % Extract filter parameters.
    h = arg1;
    theta = -h.theta*(pi/180);
    sigma = h.sigma;
    g = h.g;
    gp = h.gp;
    
    % Assign default visualization state (if not provided).
    if ~exist('arg2','var') || isempty(arg2)
       arg2 = false;
    end
    vis = arg2;    
    
end % End of input pre-processing.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part II: Evaluate separable filter kernels.

% Calculate filter kernels (if not provided by user).
if usageMode == 1

   % Determine necessary filter support (for Gaussian).
   Wx = floor((5/2)*sigma); 
   if Wx < 1
      Wx = 1
   end
   x = [-Wx:Wx];

   % Evaluate 1D Gaussian filter (and its derivative).
   g = exp(-(x.^2)/(2*sigma^2));
   gp = -(x/sigma).*exp(-(x.^2)/(2*sigma^2));

   % Store filter kernels (for subsequent runs).
   h.g = g;
   h.gp = gp;
   h.theta = -theta*(180/pi);
   h.sigma = sigma;
   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part III: Determine oriented filter response.

% Calculate image gradients (using separability).
Ix = conv2(conv2(I,-gp,'same'),g','same');
Iy = conv2(conv2(I,g,'same'),-gp','same');

% Evaluate oriented filter response.
J = cos(theta)*Ix+sin(theta)*Iy;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part IV: Visualization

% Create figure window and display results.
% Note: Will only create output window is requested by user.
if vis
   figure(1); clf; set(gcf,'Name','Oriented Filtering');
   subplot(2,2,1); imagesc(I); axis image; colormap(gray);
      title('Input Image');
   subplot(2,2,2); imagesc(J); axis image; colormap(gray);
      title(['Filtered Image (\theta = ',num2str(-theta*(180/pi)),'{\circ})']);
   subplot(2,1,2); imagesc(cos(theta)*(g'*gp)+sin(theta)*(gp'*g));
      axis image; colormap(gray);
      title(['Oriented Filter (\theta = ',num2str(-theta*(180/pi)),'{\circ})']);
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%