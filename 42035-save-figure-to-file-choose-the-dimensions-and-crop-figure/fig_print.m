function fig_print(fig,figname,dim,crop,magn_factor)
% 
% Save figure to file. Choose the dimensions and crop figure (remove
% homogeneous edges).
% 
% 
%USAGE
%-----
% fig_print(fig,figname)
% fig_print(fig,figname,dim)
% fig_print(fig,figname,dim,crop)
% fig_print(fig,figname,dim,crop,magn_factor)
% 
% 
%INPUT
%-----
% - FIG: figure handle
% - FIGNAME: file name, including extension (BMP, JPG, PNG or TIF)
% - DIM: 1x2 numeric array with the image dimensions. If DIM=[], the
%   current figure size times MAGN_FACTOR will be used.
% - CROP: 1 (crop image) or 0 (do not crop [default]). Remove homogeneous edges
% - MAGN_FACTOR: magnification factor (any positive number). Only effective
%   when DIM=[]. Default: 1
% 
% 
%OUTPUT
%------
% - FIGNAME in the current folder or in the folder specified by its path.
%   The file format depends on the given extension.
% 
% 
%EXAMPLES
%--------
% >> fig=figure; plot(rand(20,1))
% >> saveas(fig,'my_plot.png')
% >> fig_print(fig,'same_plot.png',[1200 900])
% >> fig_print(fig,'same_plot_higher_res.png',3*[1200 900])
% >> fig_print(fig,'same_plot_curr_size.png',[])
% >> fig_print(fig,'same_plot2.png',[],0,1200/560) % figure width: 560 px
% 
% When the figure is resized:
% >> oldpaperposmode = get(fig,'PaperPositionMode');
% >> set(fig,'PaperPositionMode','auto')
% >> saveas(fig,'my_plot_curr_prop.png')
% >> set(fig,'PaperPositionMode',oldpaperposmode)
% >> fig_print(fig,'same_plot_curr_size.png',[])
% >> fig_print(fig,'same_plot_curr_prop_higher_res.png',[],0,5)
% 

% Guilherme Coco Beltramini (guicoco@gmail.com)
% 2013-Apr-28, 09:28 pm


% Read input
%==========================================================================

quality = 95; % for JPEG
border  = 1;  % border width in pixels (only effective if crop=1)

if ~ishandle(fig) || ~strcmp(get(fig,'Type'),'figure')
    error('FIG is not a figure handle')
end

if nargin<3 || isempty(dim)
    dim = [];
elseif ~isnumeric(dim) || length(dim)~=2 || any(dim<=0)
    error('DIM must be an empty or 1x2 numeric array with positive numbers')
else
    dim = dim(:).';
end

if nargin<4
    crop = 0;
elseif ~isequal(crop,0) && ~isequal(crop,1)
    error('CROP must be 0 or 1')
end

if nargin<5
    magn_factor = 1;
elseif ~isnumeric(magn_factor) || length(magn_factor)~=1 || magn_factor<=0
    error('MAGN_FACTOR must be a positive number')
elseif ~isempty(dim)
    disp('MAGN_FACTOR will be ignored')
end


% File format
%------------
tmp = strfind(figname,'.');
if isempty(tmp)
    error('Could not find file extension.')
end
tmp = tmp(end) + 1;
switch figname(tmp:end)
    case 'bmp'
        f_format = '-dbmp';
    case 'jpg'
        f_format = '-djpeg';
    case 'png'
        f_format = '-dpng';
    case 'tif'
        f_format = '-dtiff';
    otherwise
        error('Unknown file extension')
end


% Get current values
%==========================================================================
oldscreenunits = get(fig,'Units');
 % - Specifies the units used to define 'Position' and 'CurrentPoint'
 %   (location of last button click in the figure: [x-coord.,y-coordinate])
 % - They are measured from the lower-left corner of the figure window
 % - Options:
 %   'inches', 'centimenters', 'points': absolute units. 1 point = 1/72 in.
 %   'normalized': lower-left corner of the figure window = [0 0]
 %                 upper-right corner = [1 1]
 %   'pixels': depends on the screen resolution
 %   'characters': Based on the size of characters in the default system
 %   font. The width of one characters unit is the width of the letter x,
 %   and the height of one characters unit is the distance between the
 %   baselines of two lines of text.

oldposition = get(fig,'Position');
% Size and location of the figure window on the screen, not including title
% bar, menu bar, tool bars, and outer edges: [left, bottom, width, height],
% where "left" and "bottom" define the distance from the lower-left corner
% of the screen to the lower-left corner of the figure window; "width" and
% "height" define the dimensions of the window. The left and bottom
% elements can be negative on systems that have more than one monitor.

oldinvhardcopy = get(fig,'InvertHardcopy');
 % 'on': the color of the figure and axes are changed to white and the axis
 %   lines, tick marks, axis labels, etc., to black. Lines, text, and the
 %   edges of patches and surfaces might be changed, depending on the print
 %   command options specified.
 % 'off': the printed output matches the colors displayed on the screen
 
oldpaperunits = get(fig,'PaperUnits');
% - Specifies the units used to define 'PaperPosition' and 'PaperSize'
% - Analogous to 'Units', but "figure window"->"page" and the options are:
%   'inches', 'centimenters', 'points' and 'normalized'

oldpaperpos = get(fig,'PaperPosition');
% Location of the figure on printed page: [left, bottom, width, height],
% where "left" and "bottom" define the distance from the lower-left corner
% of the paper to the lower-left corner of the figure; "width" and "height"
% define the dimensions of the figure.

oldpaperposmode = get(fig,'PaperPositionMode');
% 'manual': MATLAB honors the value specified by 'PaperPosition'
% 'auto': MATLAB prints the figure the same size as it appears on the
%   computer screen, centered on the page

oldpapersize = get(fig,'PaperSize');
% Size of the current 'PaperType': [width height]


% Temporarily change some figure properties
%==========================================================================

% Fix the problem with things jumping around
%-------------------------------------------
axes_child = findall(allchild(fig),'flat','Type','axes');
%axes_child = findobj(get(fig,'Children'),'flat','Type','axes');
if ~isempty(axes_child)
    oldaxesunits = cellstr(get(axes_child,'Units'));
    set(axes_child,'Units','normalized')
end

% Fix the problem with fonts getting big or small
%------------------------------------------------
notnorm_obj = findobj(fig,'FontUnits','normalized','-not');
if ~isempty(notnorm_obj)
    oldfontunits = cellstr(get(notnorm_obj,'FontUnits'));
    set(notnorm_obj,'FontUnits','normalized')
end

% Adjust figure size
%-------------------
if isempty(dim)
    set(fig,'Units','pixels')
    dim = get(fig,'Position');
    dim = dim(3:4);
end
dpi = (dim(1)/1200+dim(2)/900)/2*150*magn_factor;
newpos = [0 0 dim/dpi]*magn_factor;

set(fig,...
    'PaperUnits'       ,'inches'   ,...
    'PaperSize'        ,newpos(3:4),...
    'PaperPosition'    ,newpos     ,...
    'PaperPositionMode','manual')

% Adjust color
%-------------
set(fig,'InvertHardcopy','off')


% Save file
%==========================================================================
drawnow
print(fig,figname,f_format,sprintf('-r%d',dpi));


% Crop image (remove homogeneous edges)
%==========================================================================
if crop
    tmp = imread(figname);
    tmp = crop_img(tmp,border);
    switch f_format
        case '-dbmp'
            imwrite(tmp,figname)
        case '-djpeg'
            if quality > 100
                imwrite(tmp,figname,'Mode','lossless');
            else
                imwrite(tmp,figname,'Quality',quality);
            end
        case '-dpng'
            imwrite(tmp,figname,...
                'ResolutionUnit','meter',...
                'XResolution',dpi,...
                'YResolution',dpi);
        case '-dtiff'
            imwrite(tmp,figname,'Resolution',dpi)
    end
end


% Reset figure properties
%==========================================================================
set(fig,...
    'Units'            ,oldscreenunits ,...
    'Position'         ,oldposition    ,...
    'InvertHardcopy'   ,oldinvhardcopy ,...
    'PaperUnits'       ,oldpaperunits  ,...
    'PaperPosition'    ,oldpaperpos    ,...
    'PaperPositionMode',oldpaperposmode,...
    'PaperSize'        ,oldpapersize)
if ~isempty(axes_child)
    set(axes_child,{'Units'},oldaxesunits)
end
if ~isempty(notnorm_obj)
    set(notnorm_obj,'FontUnits',oldfontunits)
end