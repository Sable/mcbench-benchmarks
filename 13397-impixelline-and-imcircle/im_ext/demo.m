%% What's it?
% im_pix_line draws a "pixel by pixel" imline and im_circle draws a "circle 
% version" of imrect.

%% INSTALL
% im_pix_line and im_circle is adopted from imline and im_circle,respectively.
% So either of the following methods to intall is OK:
%
% * simple mode
%
%       Unzip the zip file, copy the whole folder, im_ext, to any place on matlab search path
%
% * lazy mode
%
%       Unzip the zip file. 
%       copy im_ext\im_circle.m, im_ext\im_pix_line.m to 
%       %matlabroot\toolbox\images\imuitools
%       copy im_ext\private\pixLineSymbol.m im_ext\private\defaultCircle.m 
%       to %matlabroot\toolbox\images\imuitools\private
%
%  IMPORTANT: im_pix_line uses LineTwoPnts.mexw32 to draw a discrete line.
%  If the mex file is not available on your platform, please refer to 
%
%  http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=13221&objectType=file
%
%  and then download the most up-to-date "fast bresenham" so that you can compile the
%  appropriate mex file on your platform.
%

%% usage of im_circle
% im_circle is almostly identical to imrect, for example:
figure, imshow('cameraman.tif')
h = im_circle(gca, [110,60], 30);
api = iptgetapi(h);
api.setColor([1 0 0]);

% IMPORTANT: use 'imline' here since the toolbox function 
% makeConstrainToRectFcn can only recognize one of the imline, imrect, impoint !!!
fcn =makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
api.setDragConstraintFcn(fcn);

%% usage of im_pix_line
% im_pix_line is almostly identical to imline, consider below example.
% (IMPORTANT: ensure t1_1.bmp is on your matlab search path)
imshow('t1_1.bmp');
im_pix_line(imgca,[189, 204],[195,214]);
zoom(6);
% You can try to drag the line at both end and the middle part.

%% That's all
% Have fun:)
% For any suggestions/bug report, please email to gauss.1982@gmali.com
% Thank you!
