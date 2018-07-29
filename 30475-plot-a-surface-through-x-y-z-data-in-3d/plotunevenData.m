function Z = plotunevenData(fileToRead,varargin)
% PLOTUNEVENDATA plots a 3D surface through X-Y-Z 
% interploated data-values using the SURF function.
%
% RETURNS interpolated Z-values
% INPUT parameters:
%   filetoRead : mat or xls file with X,Y,Z column vectors
%   xres, yres : scalars, used for linspace resolution
%   method : 1,2 or 3, interpolant type (NATURAL neighbor, LINEAR, NEAREST
%   datashow : true, false to switch on/switch off the data points
%   xlab,ylab,zlab : label the X,Y,Z axes
%   cmap : colormap
%
% DEFAULTS: xres=30;yres=50; method=2; datashow=true;
%           xlab='Horizontal Axis';
%           ylab='Vertical Axis';
%           zlab='Z Axis';
%           cmap='hsv';
%
%USAGE = 
%>> plotunevenData('trimesh3d.mat'); %minimal input
% 
%USAGE= 
%>> plotunevenData('trimesh3d.mat',30,50,3,false) %display Z-values but
%                                                  hide data points and use
%                                                  interpolant method 3
%
%USAGE= 
%>> plotunevenData('trimesh3d.mat',30,50,3,true); % no Z-values displayed
%                                               but display data points
%
%USAGE= 
%>> plotunevenData('toconvert.xls',30,50,3,true) %will then convert to
%                                         toconvert.xls.mat file for speed.
%
%USAGE=
%>> plotunevenData('trimesh3d.mat',30,50,1,false,'X','Y','Z') % add your
%                                                               own labels
%USAGE=
%>> plotunevenData('trimesh3d.mat',30,50,1,false,...
%                           'X','Y','Z',colormap(cool(8))) % add your own
%                                                            colormap                                                               

% Check number of inputs. 
% i.e. xres,yres,method,datashow,xlab,ylab,zlab,cmap
numOpts=size(varargin,2);
if numOpts > 8
    error('myfuns:plotunevenData:TooManyInputs', ...
        'requires at most 8 optional inputs');
end

% read X,Y,Z data from a .MAT file or from an .XLS file
if strfind(fileToRead,'.mat') >= 1
    load (fileToRead) % binary file format 
elseif strfind(fileToRead,'.xls') >= 1
    % Import the Excel file
    newNum = xlsread(fileToRead);
    % extract the column vectors x,y,z
    x = newNum(:,1);
    y = newNum(:,2);
    z = newNum(:,3);
    %save data to a 'mat' file for faster re-reading
    sFile = [fileToRead '.mat'];
    save(sFile,'x','y','z');
end

% Define parameters if not passed to function for:
% filename, the resolution of the grid for input 
% to linspace as well as interpolant method, data points
% visibility, labelling of axes and colormap.
optArgs = {30 50 2 true 'Horizontal Axis' 'Vertical Axis' 'Z Axis' 'hsv'};
[optArgs{1:numOpts}] = varargin{:};
[xres,yres,method,datashow,xlab,ylab,zlab,cmap] = optArgs{:};

% Construct the interpolant
%    'natural'   Natural neighbor interpolation
%    'linear'    Linear interpolation (default)
%    'nearest'   Nearest neighbor interpolation
%      The 'natural' method is C1 continuous except at the scattered data 
%      locations. The 'linear' method is C0 continuous, and the 'nearest' 
%      method is discontinuous.
switch method
    case 1
    F = TriScatteredInterp(x,y,z,'natural');
    interpolant = 'Natural neighbor interpolation';
    case 2
    F = TriScatteredInterp(x,y,z,'linear');
    interpolant = 'Linear interpolation (default)';
    case 3
    F = TriScatteredInterp(x,y,z,'nearest');      
    interpolant = 'Nearest neighbor interpolation';
end;
% http://www.mathworks.com/help/techdoc/learn_matlab/f3-40352.html#f3-1170
% Define the limits of the X-Y data for input to linspace
xmin = min(x); ymin = min(y);
xmax = max(x); ymax = max(y); 
% xres by xres matrix, same for yres
% Define the range and spacing of the x,y-coordinates,
% and then fit them into X-Y
[XI,YI] = meshgrid(linspace(xmin, xmax, xres),linspace(ymin, ymax, yres)); 
% Calculate ZI (Z Interpolant) in the X-Y interpolation space created by 
% TriScatteredInterp, an evenly spaced grid:
ZI = F(XI,YI);
Z = ZI;

fig1=figure;
% Generate the 3D surface
surf(XI,YI,ZI)
colormap(cmap);
xlabel (xlab, 'fontsize',12.5,'fontweight','b');
ylabel (ylab, 'fontsize',12.5,'fontweight','b');
zlabel (zlab, 'fontsize',12.5,'fontweight','b');
title(interpolant);
% Plot data points onto the 3D surface to show how good the interpolation is
if datashow 
    figure(fig1)
    hold on
    plot3(x,y,z,'marker','o','markerfacecolor','b','linestyle','none')
    hidden off 
end

end