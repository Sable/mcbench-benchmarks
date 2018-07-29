function showcamera(ax,camera)
%SHOWCAMERA: draw a schematic of a camera
%
%   SHOWCAMERA(CAMERA) draws a camera on the current axes
%
%   SHOWCAMERA(AXES,CAMERA) draws a camera on the specified axes
%
%   Example:
%   >> cameras = loadcameradata(1:3);
%   >> showcamera(cameras)
%
%   See also: LOADCAMERADATA

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

if nargin<2
    camera = ax;
    ax = gca();
end

scale = 0.2;
subsample = 16;

for c=1:numel(camera)
    cam_t = camera(c).T;
    
    % Draw the camera centre
    plot3(camera(c).T(1),camera(c).T(2),camera(c).T(3),'b.','markersize',5);
    
    % Now work out where the image corners are
    [h,w,colordepth] = size(camera(c).Image); %#ok<NASGU>
    imcorners = [0 w 0 w
        0 0 h h
        1 1 1 1];
    worldcorners = iBackProject( imcorners, scale, camera(c) );
    iPlotLine(cam_t, worldcorners(:,1), 'b-')
    hold on
    iPlotLine(cam_t, worldcorners(:,2), 'b-')
    iPlotLine(cam_t, worldcorners(:,3), 'b-')
    iPlotLine(cam_t, worldcorners(:,4), 'b-')
    
    
    
    % Now draw the image plane. We will need the coords of every pixel in order
    % to do the texturemap
    [x,y,z] = meshgrid( 1:subsample:w, 1:subsample:h, 1 );
    pix = [x(:),y(:),z(:)]';
    worldpix = iBackProject( pix, scale, camera(c) );
    smallim = camera(c).Image(1:subsample:end,1:subsample:end,:);
    surface('XData', reshape(worldpix(1,:),h/subsample,w/subsample), ...
        'YData', reshape(worldpix(2,:),h/subsample,w/subsample), ...
        'ZData', reshape(worldpix(3,:),h/subsample,w/subsample), ...
        'FaceColor','texturemap', ...
        'EdgeColor','none',...
        'CData', smallim );
end
set( ax,'DataAspectRatio', [1 1 1] )

%-------------------------------------------------------------------------%
function X = iBackProject( x, dist, camera )
%IBACKPROJECT - backproject an image location a distance DIST and return
%   the equivalent world location.
if size(x,1)==2
    x = [x;ones(1,size(x,2))];
end

X = camera.K \ x;
normX = sqrt(sum(X.*X,1));
X = X ./ repmat(normX,size(X,1),1);
X = repmat(camera.T,1,size(x,2)) - dist * camera.R'*X;

%-------------------------------------------------------------------------%
function iPlotLine(x0, x1, style)
plot3([x0(1),x1(1)], [x0(2),x1(2)], [x0(3),x1(3)], style);
