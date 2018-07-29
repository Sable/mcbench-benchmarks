function fig2img(dpi,flagScreenSize)
% saveFig: Saves the current figure to a file
%
% Inputs:
%   dpi: dpi resolution to save image (default = 300 dpi)
%   flagScreenSize: figure size to use. 0 = use default figure size,  
%                   1 = use actual size of figure (default = 0)
%
% Usage:
%
%   This function only saves the CURRENT FIGURE to an image file. The current figure
%   is the last figure that you clicked or generated. If you are not sure
%   which figure is current, simply click on the figure and then run
%   fig2img.
%   
%   Example 1: Save current figure using defaults (300 dpi, png file, default figure size).
%              Use command: fig2file()
%   Example 2: Save current figure as image with 600 dpi using actual size of figure.
%              Use command: fig2file(600,1)
%   Example 3: Save current figure as a image with 300 dpi using default fig size.
%              Use command: fig2file(300,1)
%
% Note: See documentation on 'print' for other types of image formats and other info.

    if nargin<2; flagScreenSize=false; end
    if nargin<1; dpi='-r300'; end
    if isnumeric(dpi)
        dpi=['-r' num2str(dpi)];
    else
        if isempty(findstr('-r',dpi)); dpi=['-r' dpi]; end
    end

    %get file name and path
    [fn fp fi]=uiputfile( ...
      {'*.png', 'PNG (*.png)';...
      '*.jpeg','JPEG (*.jpeg)';...
      '*.bmp','Bitmap (*.bmp)';...
      '*.tif','TIFF (*.tif)';...
      '*.eps','EPS color (*.eps)';...
      '*.pdf','PDF (*.pdf)'},...
      'Save Figure As Image'); 

    if ~fi; return; end %Check if filename was seleted...must select a file

    [a b ext]=fileparts(fn); %get file extension
    clear a b; % clear some data

    %determine image file format to use
    switch ext
        case {'.png','.jpeg','.bmp','.eps','.pdf'}
            format=['-d' ext(2:end)];
        case '.tif'
            format=['-d' ext(2:end) 'f'];
    end

    %determine what size to save figure
    if flagScreenSize; 
        ppm=get(gcf,'PaperPositionMode');
        set(gcf,'PaperPositionMode','auto')
    end

    %save figure
    print(format,dpi,fullfile(fp,fn)) %print to file

    %reset screen settings if needed
    if flagScreenSize; set(gcf,'PaperPositionMode',ppm); end % set it back
end