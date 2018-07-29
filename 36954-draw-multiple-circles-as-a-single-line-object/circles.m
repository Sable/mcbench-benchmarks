function [myhandle, x_circle, y_circle] = circles(radii,centers,varargin)
% Plot multiple circles as a single line object...very fast, very efficient!
%
% circles(radii,centers) plots circles of radius values specified by RADII, 
%     at centers specified by CENTERS.
% circles(radii,centers,'PropertyName',propertyvalue,...)
%         Will accept as inputs any valid properties
%         accepted by PLOT.
% [h,x_circle,y_circle] = circles(...)
%         Also provides handle to (single-plot) circle
%         object, plotted x-values, and plotted y-values. 
% 
% NOTE: x- and y- values for each circle will be terminated
%       by NaNs in the output x_circle, y_circle vectors! 
%
% INPUTS:
%     r        A vector of n radii
%     centers  An n x 2 array of x,y center coordinates
%
%     Optional Parameter-Value Pairs:
%        Resolution: Stepsize for plotting from theta = 0 to
%                    theta = 360 (Default = 1)
%        Any valid PV-pair accepted by PLOT
%
% EXAMPLES
%
%%% Example 1: Plot a single circle:
%
% r = 10; c = [3,5];
% circles(r,c,'color','g','linewidth',2)
%
%
%%% Example 2: Plot 200 random-sized and centered circles
%%% (Note: this is MUCH faster than drawing them one-by-one,
%%% but the speed gain is at the cost of getting a single
%%% line-object handle rather than a vector of them.)
%
% tic;
% n = 1000;
% r = rand(n,1)*100;
% c = rand(n,2)*300;
% [h,xs,ys] = circles(r,c,...
%         'color','r','linewidth',1,'resolution',1);
% axis equal
% t_allAtOnce = toc
%
%
%%% Example 3: (FOR COMPARISON ONLY!!!)
%%% (Using the r,c generated above:)
%
% tic;
% for ii = 1:numel(r)
%   circles(r(ii),c(ii,:),'color','r','linewidth',1,'resolution',1);
% end
% t_oneAtATime = toc
% fprintf('Plotting %d circles was %0.2f x faster as a single object!\n',n,t_oneAtATime/t_allAtOnce)
%
% Written by Brett Shoelson, PhD 8/3/98.
% brett.shoelson@mathworks.com
%
% MODIFICATIONS:
% Vectorized 11/20/01
% Arg for resolution 03/08/08
% 12/06/11 Modified as CIRCLES to accept multiple radii and centers,
%   and to vectorize all as a single line object.
%
% Copyright 2012 The MathWorks, Inc.

if nargin < 2
    error('CIRCLES requires a minimum of 2 input arguments.');
end

if rem(nargin,2) ~= 0
    % Odd number of inputs!
    error('CIRCLES: Parameter-Values must be entered in valid pairs')
end

[PVs,resolution] = parsePVs(varargin);

theta=0:resolution:360;

x_circle = bsxfun(@times,radii,cos(theta*pi/180));
x_circle = bsxfun(@plus,x_circle,centers(:,1));
x_circle = cat(2,x_circle,nan(size(x_circle,1),1));
x_circle =  x_circle';
x_circle = x_circle(:);

y_circle = bsxfun(@times,radii,sin(theta*pi/180));
y_circle = bsxfun(@plus,y_circle,centers(:,2));
y_circle = cat(2,y_circle,nan(size(y_circle,1),1));
y_circle =  y_circle';
y_circle = y_circle(:);

oldhold = ishold;
hold on;
myhandle = plot(x_circle,y_circle);

% Apply PV pairs
for ii = 1:2:numel(PVs)
    set(myhandle,PVs{ii},PVs{ii+1})
end

if ~oldhold,hold off;end
if nargout < 3
    clear y_circle
end
if nargout < 2
    clear x_circle
end
if nargout < 1
    clear myhandle
end

function [PVs,resolution] = parsePVs(PVs)
resolution = 1;
for ii = 1:2:numel(PVs)
    if strcmpi(PVs{ii},'resolution')
        resolution = PVs{ii+1};
        PVs = PVs(setdiff(1:numel(PVs),[ii,ii+1]));
        return
    end
end
    