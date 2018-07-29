function varargout = anaglyph(varargin)
% ANAGLYPH - displays an anaglyph obtained by two stereoscopical images
% 
% anaglyph with no arguments, opens a dialog to pick an image which contains
% two stereoscopical images in a single image file.
% 
% anaglyph('filename') displays an anaglyph of the image "filename"
% (with extension), which contains two stereoscopical images in a single
% image file (bmp, jpg, or other supported image type).
% 
% anaglyph('filename1', 'filename2') displays an anaglyph from the two images
% "filename1", "filename2" (with extension) one for the right eye and one for
% the left one.
% 
% anaglyph(A) displays an anaglyph of the image A, in memory,
% which contains two stereoscopical images in a single image
% file (bmp, jpg, or other supported image type).
% 
% anaglyph(A,B) displays an anaglyph from the two images A and B, in memory,
% (with extension) one for the right eye and one for the left one.
% 
% Inputs: one or two names of image files or of matlab variables
% 
% Outputs (optional):
%    the figure handle to the anaglyph
%
% Notes:
% One can swap the two images during the visualization.
% 
% Version 2.0 NEWS
% - now plots also images in memory
% - with no args, opens a dialog to choose the image
% - zoom function
% 
% Example: 
%    anaglyph('foto3d.bmp')
%
% Other m-files required: none
% Subfunctions: plotAnaglyph, swap
% MAT-files required: none
%
% See also: stereoview
% 
% Author: Iari-Gabriel Marino, Ph.D., nonlinear optics
% University of Parma, Dept. of Physics, ITALY
% email address: iarigabriel.marino@fis.unipr.it
% Website: http://www.fis.unipr.it/raman/index2.htm
% Personal: http://www.fis.unipr.it/home/marino/
% November 2006; Last revision: 6-Nov-2006
% 
%------------- BEGIN CODE --------------

switch nargin
    case 0
        [imageName, pathname] = uigetfile({'*.*'}, 'Pick a stereo image..');
        m = imread([pathname imageName(1:end-4)],imageName(end-2:end));
        [x,y,z] = size(m);
        if rem(y,2) == 0,
            dx = m(:,1:y/2,:);
            sx = m(:,y/2+1:end,:);
        elseif rem(y,2) == 1,
            dx = m(:,1:fix(y/2),:);
            sx = m(:,fix(y/2)+1:end-1,:);
        end
    case 1
        % cuts the image in two
        imageName = varargin{1};
        if isstr(imageName) % if it is a string, I load it
            m = imread(imageName(1:end-4),imageName(end-2:end));
        else % else it is a variable yet in memory:
            m = imageName;
        end
        [x,y,z] = size(m);
        if rem(y,2) == 0,
            dx = m(:,1:y/2,:);
            sx = m(:,y/2+1:end,:);
        elseif rem(y,2) == 1,
            dx = m(:,1:fix(y/2),:);
            sx = m(:,fix(y/2)+1:end-1,:);
        end
    case 2
        % assign each image
        namedx = varargin{1};
        namesx = varargin{2};
        if and(isstr(namedx),isstr(namesx)) % if they are strings, I load them
            dx = imread(namedx(1:end-4),namedx(end-2:end));
            sx = imread(namesx(1:end-4),namesx(end-2:end));
        else % else they should be variable yet in memory
            dx = namedx;
            sx = namesx;
        end
end

figH = figure;
set(figH,'userdata',0);

swapButt = uicontrol(figH,'style','pushbutton','String','Swap RL','value',0,'pos',[20 10 58 20]);
zoomInButt = uicontrol(figH,'style','pushbutton','String','Zoom +','pos',[80 10 58 20]);
zoomOutButt = uicontrol(figH,'style','pushbutton','String','Zoom -','pos',[140 10 58 20]);

set(swapButt,'callback',{@swap,dx,sx,figH});
set(zoomInButt,'callback',{@zoomCLB,-0.1})
set(zoomOutButt,'callback',{@zoomCLB,+0.1})

plotAnaglyph(dx,sx);

if nargout == 1,
    varargout = {figH};
end

% -------------------------------------------------------
% Plots the anaglyphic image
function plotAnaglyph(A,B);

r = zeros(size(A));
gb = zeros(size(B));

r(:,:,1) = double(A(:,:,1));
gb(:,:,2:3) = double(B(:,:,2:3));

% subplot(1,2,1)
% image(uint8(r)); axis equal
% 
% subplot(1,2,2)
% image(uint8(gb)); axis equal

image(uint8(r+gb));
axis equal
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'color',[0 0 0])
set(gcf,'color',[0 0 0])
shg

% -------------------------------------------------------
% Swaps right/left
function swap(UiHandle,action,A,B,figH)
flag = get(figH,'userdata');
switch flag
case 1
    plotAnaglyph(A,B);
    set(figH,'userdata',0);
case 0
    plotAnaglyph(B,A);
    set(figH,'userdata',1);
end
% -------------------------------------------------------
% Zoom
function zoomCLB(UiHandle,action,D)
origCVA = get(gca,'CameraViewAngle');
set(gca,'CameraViewAngle',origCVA+D)
%------------- END OF CODE --------------