% Adobe Photoshop PSD file reader and info functions.
%
% These functions will read image data and associated metadata from PSD
% files.  Images must either be uncompressed or compressed with Packbits
% (RLE) encoding.  Currently metadata support is limited to basic image
% details, although the raw metadata bytes for other fields are returned
% in the metadata structure.
%
% To use these functions with IMREAD and IMFINFO, add the directory
% containing these files to your path and register them once per MATLAB
% session in the IMFORMATS registry.  The following code will do this.

formats = imformats;

psdFormat.ext = 'psd';
psdFormat.isa = '';
psdFormat.info = @impsdinfo;
psdFormat.read = @readpsd;
psdFormat.write = '';
psdFormat.alpha = 0;
psdFormat.description = 'Adobe Photoshop (PSD)'
psdFormat.isa = @ispsd;

% For MATLAB 6.x, use the next line and comment out lines (b) and (c).
% formats(end + 1) = psdFormats;  % (a)

% For MATLAB 7 and later, use the next line and comment out lines (a) and (c).
% imformats('add', psdFormat);  % (b)

% This line should always be commented out once you pick line (a) or (b).
warning('Adobe Photoshop PSD format is not yet in the registry.')  % (c)
