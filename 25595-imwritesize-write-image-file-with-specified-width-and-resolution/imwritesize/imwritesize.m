function imwritesize(A, filename, width, resolution)
%IMWRITESIZE Write image file with specified width and resolution
%   imwritesize(A, FILENAME, WIDTH) writes the image A to the specified FILENAME
%   in either TIFF or PNG format. Resolution information is written into the
%   file so that many document and graphics printing applications (e.g.,
%   Microsoft Word, Adobe Photoshop and Illustrator, PDFLaTeX) will treat the
%   image as having the specified WIDTH in inches.  The input image A can be
%   either grayscale or RGB; indexed images are not supported.
%
%   If the specified FILENAME ends in .tif, .tiff, or .png, the appropriate file
%   format will be used.  Otherwise, the image will be written as a TIFF file
%   using the specified FILENAME with no additional extension.
%
%   imwritesize(A, FILENAME, WIDTH, RESOLUTION) resizes the image A if necessary
%   so that it can be written to the file with both the specified WIDTH in
%   inches as well as the specified RESOLUTION in pixels per inch.
%
%   Terminology note: When publishers use the term "dpi" (dots per inch) in this
%   context, they usually mean image pixels per inch.
%
%   Examples
%   --------
%       % Write out an image as a PNG file so that document and
%       % graphics applications will treat it as being 2 inches wide.
%       A = imread('rice.png');
%       imwritesize(A, 'rice_2in.png', 2);
%
%       % Write out an image as a TIFF file so that document and graphics
%       % applications will treat it as being 3.5 inches wide with a resolution of
%       % 300 dpi.
%       A = imread('rice.png');
%       imwritesize(A, 'rice_3.5in_300dpi.tif', 3.5, 300);

%   Steven L. Eddins
%   Copyright 2009 The MathWorks, Inc.

[path, name, ext] = fileparts(filename);
if strcmpi(ext, '.tif') || strcmpi(ext, '.tiff')
    format = 'tif';

elseif strcmpi(ext, '.png')
    format = 'png';
    
else
    format = 'tif';
end

[M, N, P] = size(A);

if nargin > 3
    % The caller specified the desired resolution.
    desired_N = width * resolution;
    if verLessThan('images', '5.4')
        error('If you specify the resolution, this function requires Image Processing Toolbox version 5.4 (R2007a) or later.');
    end
    A = imresize(A, 'OutputSize', [NaN desired_N]);
else 
    % Compute resolution automatically to achieve the desired width without
    % resizing the image.
    resolution = N / width;
end

if strcmp(format, 'tif')
    % Resolution is already in the right units.  Round to nearest integer.
    resolution = round(resolution);
    imwrite(A, filename, format, 'Resolution', resolution);
    
else
    % Convert pixels per inch to pixels per meter and round to nearest integer. 
    resolution = round(resolution * 100 / 2.54);
    imwrite(A, filename, format, 'ResolutionUnit', 'meter', ...
        'XResolution', resolution, 'YResolution', resolution);
end

%
% verLessThan downloaded from
% http://www.mathworks.com/support/solutions/data/1-38LI61.html?solution=1-38LI61
% on October 16, 2009.
% 

function result = verLessThan(toolboxstr, verstr)
%verLessThan Compare version of toolbox to specified version string.
%   verLessThan(TOOLBOX_DIR, VERSION) returns true if the version of
%   the toolbox specified by the string TOOLBOX_DIR is older than the
%   version specified by the string VERSION, and false otherwise. 
%   VERSION must be a string in the form 'major[.minor[.revision]]', 
%   such as '7', '7.1', or '7.0.1'. If TOOLBOX_DIR cannot be found
%   on MATLAB's search path, an error is generated.
%
%   Examples:
%       if verLessThan('images', '4.1')
%           error('Image Processing Toolbox 4.1 or higher is required.');
%       end
%
%       if verLessThan('matlab', '7.0.1')
%           % Put code to run under MATLAB older than MATLAB 7.0.1 here
%       else
%           % Put code to run under MATLAB 7.0.1 and newer here
%       end
%
%   See also MATLABPATH, VER.

%   Copyright 2006-2007 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2007/02/23 13:28:34 $
    
if nargin < 2
    errstr = 'Not enough input arguments.';
    if errorSupportsIdentifiers
        error('MATLAB:nargchk:notEnoughInputs', errstr)
    else
        error(errstr)
    end
end

if ~ischar(toolboxstr) | ~ischar(verstr)
    errstr = 'Inputs must be strings.';
    if errorSupportsIdentifiers
        error('MATLAB:verLessThan:invalidInput', errstr)
    else
        error(errstr)
    end
end

toolboxver = ver(toolboxstr);
if isempty(toolboxver)
    errformat = 'Toolbox ''%s'' not found.';
    if errorSupportsIdentifiers
        error('MATLAB:verLessThan:missingToolbox', errformat, toolboxstr)
    else
        error(sprintf(errformat, toolboxstr))
    end
end

toolboxParts = getParts(toolboxver(1).Version);
verParts = getParts(verstr);

result = (sign(toolboxParts - verParts) * [1; .1; .01]) < 0;

function parts = getParts(V)
    parts = sscanf(V, '%d.%d.%d')';
    if length(parts) < 3
       parts(3) = 0; % zero-fills to 3 elements
    end

function tf = errorSupportsIdentifiers
    % Determine, using code that runs on MATLAB 6.0 or later, if
    % error identifiers should be used when calling error().
    tf = 1;
    eval('lasterr('''','''');','tf = 0;');

    