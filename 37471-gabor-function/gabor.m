%Generate 2D Gabor Patch
%
% GABOR
%   Generates a spatially oriented sinusoidal grating multiplied by a gaussian
%   window. Gabor functions have been used to model simple cell receptive fields
%   and are commonly used filters for edge detection.
%
% USAGE
%   [x y F] = gabor(varargin)
%
%   Returns:
%       x: grid of x-values
%       y: grid of y-values
%       F: gabor function evaluated at (x,y) points
%
%   Parameters (Default):
%       theta (2*pi*rand): orientation of the gabor patch
%       lambda (20): spatial wavelength
%       Sigma (10): standard deviation of gaussian window
%       width (256): width of generated image
%       height (256): height of generated image
%       px (rand): horizontal center of gabor patch, relative to the image width (must be between 0 and 1)
%       py (rand): vertical center of gabor patch, relative to the image height (must be between 0 and 1)
%
% EXAMPLE
%   [x y F] = gabor;
%   pcolor(x,y,F); axis image;
%   shading('interp'); colormap copper;
%
% VERSION 1.0, Thu Jul 12 09:47:52 2012
%
% AUTHOR: Niru Maheswaranathan
%         nirum@stanford.edu

function [x y F] = gabor(varargin)

    % Parse Input
    p = inputParser;
    addParamValue(p,'theta',2*pi*rand,@isnumeric);
    addParamValue(p,'lambda',20,@isnumeric);
    addParamValue(p,'Sigma',10,@isnumeric);
    addParamValue(p,'width',256,@isnumeric);
    addParamValue(p,'height',256,@isnumeric);
    addParamValue(p,'px',rand*0.8 + 0.1,@isnumeric);
    addParamValue(p,'py',rand*0.8 + 0.1,@isnumeric);
    p.KeepUnmatched = true;
    parse(p,varargin{:});

    % Generate mesh
    [x y] = meshgrid(1:p.Results.width, 1:p.Results.height);

    % Center of gaussian window
    cx = p.Results.px*p.Results.width;
    cy = p.Results.py*p.Results.height;

    % Orientation
    x_theta=(x-cx)*cos(p.Results.theta)+(y-cy)*sin(p.Results.theta);
    y_theta=-(x-cx)*sin(p.Results.theta)+(y-cy)*cos(p.Results.theta);

    % Generate gabor
    F = exp(-.5*(x_theta.^2/p.Results.Sigma^2+y_theta.^2/p.Results.Sigma^2)).*cos(2*pi/p.Results.lambda*x_theta);

end
