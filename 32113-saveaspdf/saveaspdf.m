function saveaspdf(h,filename)
%SAVEASPDF Save a figure as a clean pdf file ready for publication.
%   saveaspdf saves the current figure to the path defined in the global
%   SAVEASPDF_PATH, or to your Desktop if no path is specified. The
%   figure's 'Name' property is used as the filename.
%
%   saveaspdf(filename) saves the current figure as filename to the path
%   defined in the global SAVEASPDF_PATH, or to your Desktop if no path is
%   specified.
%
%   saveaspdf(h,filename) saves the figure with handle h as filename to the
%   path defined in the global SAVEASPDF_PATH, or to your Desktop if no
%   path is specified.
%
%   saveaspdf defines several globals which affect its output:
%
%      SAVEASPDF_DPI = 300            - The resolution of the pdf.
%      SAVEASPDF_PATH = ~/Desktop     - Where the pdf is saved.
%      SAVEASPDF_SCALELINEWIDTH = 1.8 - All lines and fonts are scaled by
%      SAVEASPDF_SCALEFONTSIZE = 1.1    these factors before printing. The
%                                       figure is returned to its original 
%                                       state after printing.
%      SAVEASPDF_SIZE = []            - Set the output dimensions to [width
%                                       height] in centimeters. If empty,
%                                       the figure's dimensions are used.
%      SAVEASPDF_TRANSPARENT = false  - Set to true change the background
%                                       to be transparent (experimental).
%
%   See also saveas, print.

%   Note: add the following lines to Matlab's ghostscript.m for better
%   quality prints of figures with gradients or transparency. Source:
%   www.histed.org/wiki/index.php?title=Controlling_matlab's_pdf_output.
%
%   % In between "fprintf(rsp_fid, '-sOutputFile="%s"\n', pj.GhostName );"
%   % and "fclose(rsp_fid);":
%   if strcmp(pj.GhostDriver, 'pdfwrite')
%       % Uncomment to embed images into file as ZIP not jpeg compressed
%       fprintf(rsp_fid, ['-dAutoFilterColorImages=false ' ...
%           '-dColorImageFilter=/FlateEncode\n']);
%       % control resolution/downsampling of embedded images
%       fprintf(rsp_fid, '-dDownsampleColorImages=false\n');
%       %fprintf(rsp_fid, '-dColorImageDownsampleThreshold=1.5\n');
%       %fprintf(rsp_fid, '-dColorImageResolution=300\n');
%   end

%   Version: 07/07/11
%   Authors: Laurent Sorber (Laurent.Sorber@cs.kuleuven.be)

% Define globals.
global SAVEASPDF_DPI;
global SAVEASPDF_PATH;
global SAVEASPDF_SCALELINEWIDTH;
global SAVEASPDF_SCALEFONTSIZE;
global SAVEASPDF_SIZE;
global SAVEASPDF_TRANSPARENT;

% Set up default values.
if nargin == 1 && ischar(h)
    filename = h;
    h = gcf;
elseif nargin == 0
    h = gcf;
    filename = get(h,'Name');
    if isempty(filename)
        filename = ['Figure ' int2str(gcf)];
    end
end
if ~isempty(SAVEASPDF_DPI)
    dpi = SAVEASPDF_DPI;
else
    dpi = 300;
end
if ~isempty(SAVEASPDF_PATH)
    path = SAVEASPDF_PATH;
else
    if ispc, path = 'USERPROFILE'; else path = 'HOME'; end
    path = fullfile(getenv(path),'Desktop');
end
filename = fullfile(path,regexprep(filename,'\.[a-zA-Z]+','.pdf'));
if ~isempty(SAVEASPDF_SCALELINEWIDTH)
    scalelw = SAVEASPDF_SCALELINEWIDTH;
else
    scalelw = 1.8;
end
if ~isempty(SAVEASPDF_SCALEFONTSIZE)
    scalefs = SAVEASPDF_SCALEFONTSIZE;
else
    scalefs = 1.1;
end
if ~isempty(SAVEASPDF_SIZE)
    size = SAVEASPDF_SIZE;
else
    size = [];
end
if ~isempty(SAVEASPDF_TRANSPARENT)
    trans = SAVEASPDF_TRANSPARENT;
else
    trans = false;
end

% Backup current settings.
oldUnits = get(h,'Units');
oldPaperUnits = get(h,'PaperUnits');
oldPaperPosition = get(h,'PaperPosition');
oldPaperSize = get(h,'PaperSize');
axes = findall(h,'type','axes');
lines = [findall(h,'type','line'); axes];
text = [findall(h,'type','text'); axes];
oldFigColor = get(h,'Color');
oldAxesColor = get(axes,'Color');
oldLineWidth = get(lines,'LineWidth');
oldFontSize = get(text,'FontSize');
if ~iscell(oldAxesColor), oldAxesColor = {oldAxesColor}; end
if ~iscell(oldLineWidth), oldLineWidth = num2cell(oldLineWidth); end
if ~iscell(oldFontSize), oldFontSize = num2cell(oldFontSize); end

% Scale the line width and font size, reset units and update the positions.
set(lines,{'LineWidth'},num2cell(cellfun(@(x)x*scalelw,oldLineWidth)));
set(text,{'FontSize'},num2cell(cellfun(@(x)round(x*scalefs),oldFontSize)));
set(h,'Units','centimeters');
set(h,'PaperUnits','centimeters');
if isempty(size)
    curPosition = get(h,'Position');
    set(h,'PaperPosition',[0,0,curPosition(3:4)]);
    set(h,'PaperSize',curPosition(3:4));
else
    set(h,'PaperPosition',[0,0,size]);
    set(h,'PaperSize',size);
end
if trans
    set(h,'Color','none');
    set(axes,'Color','none');
end

% Print the pdf.
print(h,'-dpdf',sprintf('-r%d',dpi),filename);

% Restore the previous settings.
if trans
    set(h,'Color',oldFigColor);
    set(axes,{'Color'},oldAxesColor);
end
set(h,'Units',oldUnits);
set(h,'PaperUnits',oldPaperUnits);
set(h,'PaperPosition',oldPaperPosition);
set(h,'PaperSize',oldPaperSize);
set(text,{'FontSize'},oldFontSize);
set(lines,{'LineWidth'},oldLineWidth);
