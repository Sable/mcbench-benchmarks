function varargout = leafarea(varargin)
%Created for the leaf area estimation in a plane with images taken by a
%digital camera.
%Images must be registered orthogonally in a plane to plane fashion through perspective transformation.
%Registed images then be transformed to a binary images with IMAGETOOL of
%UTHSCSA( The University of Texas Health Science Center, San Antonio, Texas.)
% with manual threshholdings.
% Author: Wang Qian
% email: wangqian1@yahoo.com
% 8/5/2004
 

error(nargchk(0,1,nargin));
if (nargin == 0),
     [filename, pathname] = uigetfile( ...
	       {'*.jpg;*.tif;*.gif;*.png;*.bmp', ...
		'All MATLAB Image Files (*.jpg,*.tif,*.gif,*.png,*.bmp)'; ...
		'*.jpg;*.jpeg', ...
		'JPEG Files (*.jpg,*.jpeg)'; ...
		'*.tif;*.tiff', ...
		'TIFF Files (*.tif,*.tiff)'; ...
		'*.gif', ...
		'GIF Files (*.gif)'; ...
		'*.png', ...
		'PNG Files (*.png)'; ...
		'*.bmp', ...
		'Bitmap Files (*.bmp)'; ...
		'*.*', ...
		'All Files (*.*)'}, ...
	       'Select image file');
     if isequal(filename,0) | isequal(pathname,0)
	  return
     else
	  imagename = fullfile(pathname, filename);
     end
elseif nargin == 1,
     imagename = varargin{1};
     [path, file,ext] = fileparts(imagename);
     filename = strcat(file,ext);
end   
pic = imread(imagename);
imshow(pic)
FigName = ['IMAGE: ' filename];
set(gcf,'Units', 'normalized', ...
	'Position', [0 0.125 1 0.85], ...
	'Name', FigName, ...
	'NumberTitle', 'Off', ...
	'MenuBar','None')
set(gca,'Units','normalized','Position',[0  0  1   1]);
bw=im2bw(pic);
[labeled,numobjects]=bwlabel(bw,4);
data=regionprops(labeled,'basic');
area=[data.Area]';
prompt={'Enter the scale in mm',...
        'Enter the scale in pixels:'};
def={'1','1'};
dlgTitle='LEAFAREA: user input required';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
Scaledata = str2num(char(answer{:}));
scale=Scaledata(1)/Scaledata(2);
fprintf('\n This program find individual leaf areas in an image')
numobjects
area=area.*scale^2
close(FigName);
clear

