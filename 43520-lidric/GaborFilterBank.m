% Written by Sebastian Zambanini                                          
% web   : http://www.caa.tuwien.ac.at/cvl/people/zamba/                                     
% email : zamba@caa.tuwien.ac.at  
% Code is based on paper "A Local Image Descriptor Robust to Illumination
% Changes", SCIA 2013
% Version: 1.02


function GFB = GaborFilterBank(resolution,varargin)
% FUNCTION generates Gabor Feature Map
%
%   GFB = GaborFilterBank(resolution)   
%   GFB = GaborFilterBank(resolution,orientations, scales, c, gamma)
%   GFB = GaborFilterBank(resolution,orientations, scales, c, gamma, spatial_only)
%
% INPUT :
%   resolution - output resolution of frequency domain filters (=size of image where the filters should be applied to)
%	orientations - number of orientations (default: 6)
%	scales  - vector of filter scales (default: [1 sqrt(2) 2 2*sqrt(2) 4
%	sqrt(2)*4 8 8*sqrt(2)])
%	c - constant factor that the Gaussian sigma is multiplied with
%	(default: 0.6)
%	gamma  - aspect ratio of the filter (default: 1.0)
%   spatial_only - only filters in the spatial domain ar created; this
%   saves runtime in the creation of the filter bank but later filtering is
%   slower (default: false)
%
% OUTPUT :
%	GFB - Gabor filter bank as struct:
%	GFB.scale(m).orient(n).spatial/frequency
%	are the spatial/frequency domain filters at the m-th scale and n-th
%	orientation
%
% If no input parameters are supplied, the default values are used


if nargin==1
    orientations = 6;
    scales = [2 2*sqrt(2) 4 sqrt(2)*4 8 8*sqrt(2) 16 16*sqrt(2)];
    c = 0.6;
    gamma = 1.0;
    spatial_only = false;
elseif nargin==5
    orientations = varargin{1};
    scales = varargin{2};
    c = varargin{3};
    gamma = varargin{4};
	spatial_only = false;
elseif nargin==6
    orientations = varargin{1};
    scales = varargin{2};
    c = varargin{3};
    gamma = varargin{4};
    spatial_only = varargin{5};
else
    error('Wrong number of input parameters.')
end

%GFB = cell(length(scales),orientations);

%generate vector of orientations
thetas = linspace(0,pi,orientations+1);
thetas = thetas(1:end-1);

row = 1;
col = 1;

for omega = scales
    for theta = thetas
        sigma = c*omega;
        sigma_x = sigma;
        sigma_y = sigma/gamma;

        % bounding box
        nstds = 3;
        xmax = max(abs(nstds*sigma_x*cos(theta)),abs(nstds*sigma_y*sin(theta)));
        xmax = ceil(max(1,xmax));
        ymax = max(abs(nstds*sigma_x*sin(theta)),abs(nstds*sigma_y*cos(theta)));
        ymax = ceil(max(1,ymax));
        xmin = -xmax; ymin = -ymax;
        [x,y] = meshgrid(xmin:xmax,ymin:ymax);

        % rotation 
        x_theta=x*cos(theta)+y*sin(theta);
        y_theta=-x*sin(theta)+y*cos(theta);

        G= exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/omega*x_theta);

        %normalise such that sum is 0
        G=G-mean2(G);
        G=G/sum(sum(abs(G)));   
        GFB.scale(row).orient(col).spatial = G;
        if ~spatial_only
            F = fft2(G,resolution(1),resolution(2));
            GFB.scale(row).orient(col).frequency = F;
            GFB.scale(row).orient(col).offset = -floor(size(G)/2);
        end
        col = col+1;
    end
    row = row+1;
    col = 1;
end

