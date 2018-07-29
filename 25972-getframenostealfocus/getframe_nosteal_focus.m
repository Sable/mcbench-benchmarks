function frame = getframe_nosteal_focus(fig, resolution, dpi)
%GETFRAME_NOSTEAL_FOCUS Same as getframe, but does not focus figure
%
%  GETFRAME_NOSTEAL_FOCUS captures the current figure at 1200x900
%  resolution and 96 dpi
%
%  GETFRAME_NOSTEAL_FOCUS(FIG) captures the figure FIG at 1200x900
%  resolution and 96 dpi
%
%  GETFRAME_NOSTEAL_FOCUS(FIG, RESOLUTION) captures the figure FIG
%  at the resolution RESOLUTION, e.g. RESOLUTION = [1200 900], and
%  96 dpi
%
%  GETFRAME_NOSTEAL_FOCUS(FIG, RESOLUTION, DPI) captures the figure FIG
%  at the resolution RESOLUTION, and DPI dots per inch.
%
%See also: getframe
%
%Written by Erik Sällström
    
    % Set current figure to the figure to capture if not specified
    if (~exist('fig', 'var'))
        fig = gcf;
    end
    
    % Set default resolution if not set
    if (~exist('resolution', 'var'))
        resolution = [1200, 900];
    end
    
    % Set default dpi if not set
    if (~exist('dpi', 'var'))
       dpi = 96;
    end
    
    % Get a filename for a temporary file
    tempfilename = [tempname '.tif'];
    
    % Set the figure size on paper!
    set(fig, 'PaperPosition', [1 1 resolution/dpi]);
    
    % Print figure to a file
    print('-dtiffnocompression', ['-r' num2str(dpi)], ['-f' ...
                        num2str(fig)], tempfilename);
    
    % Load picture
    frame.cdata = imread(tempfilename);
    frame.colormap = [];
    
    % Delete temporary file
    delete(tempfilename);
    
end
