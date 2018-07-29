function [ magic, offset, msg ] = pnmmagic( fid, fmt )
%PNMMAGIC Find and identify magic number in PBM/PGM/PPM file.
%
%   [ MAGIC, OFFSET, MSG ] = PNMMAGIC( FID ) scans the file with
%   filehandle FID for a PNM file magic number.
%
%   [ ... ] = PNMMAGIC( FID, FMT ) allows a restriction on the image
%   formats to look for. FMT must be one of 'pbm', 'pgm', 'ppm' or any
%   combination if put in a list (cell array). The special string 'pnm'
%   indicates any of 'pbm', 'pgm' and 'ppm'. If FMT is omitted, 'pnm' is
%   used.
%
%   MAGIC is the magic number found and OFFSET is the offset of the
%   magic number within the file. MSG contains an error message if the
%   search for the magic number failed, otherwise MSG is empty.
%
%   If PNMMAGIC succeeds, the file position indicator will be right
%   after the magic number so there is no need to call FSEEK when the
%   rest of the image is to be read. If PNMMAGIC fails, the file
%   position indicator will be at the end of the file.
%
%   PNM is not an image format by itself but means any of PBM, PGM, PPM.

%   Don't call error() if there is something wrong with the image file,
%   only if there is something wrong with the way this program is
%   called.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-05-10 19:03:42
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

%
% Checks input arguments and assign default value to omitted argument.
%
error( nargchk( 1, 2, nargin ) );
if nargin < 2
   fmt = 'pnm';
end
if all( fid ~= fopen( 'all' ) )
   error( 'Invalid file identifier.' );
end

% Make sure the format variable is a list (cell array).
if ischar( fmt )
   fmt = { fmt };
end

% From the list of formats create a list of magic numbers to look for.
magics = {};
for i = 1:length(fmt)
   switch lower( fmt{i} )
      case 'pbm'                                % Portable bitmap.
         magics = { magics{:}, 'P1', 'P4' };
      case 'pgm'                                % Portable graymap.
         magics = { magics{:}, 'P2', 'P5' };
      case 'ppm'                                % Portable pixmap.
         magics = { magics{:}, 'P3', 'P6' };
      case 'pnm'                                % Portable anymap.
         magics = { 'P1', 'P2', 'P3', 'P4', 'P5', 'P6' };
      otherwise
         error( [ 'Invalid format string: ' fmt ] );
   end
end

% Initialize output arguments.
magic  = '';                    % Magic number string.
offset = [];                    % Offset of magic number within file.
msg    = '';                    % Error message string.

while 1

   % The magic number should be followed by whitespace, so we can use
   % FSCANF to get the magic number.
   [ str, count ] = fscanf( fid, '%s', 1 );

   % Look for magic number.
   if any( strcmp( str, magics ) )
      magic = str;
      offset = ftell( fid ) - 2;   % Subtract length of magic number.
      return
   end

   %
   % If a magic number was not found, start scanning from the beginning
   % of the next line of the file. We don't use FGETL to get the next
   % line since the file might be enormous and contain only one line.
   %
   blocksize = 8192;            % Number of bytes read at a time.
   while 1

      % Read a chunk of data from the file.
      [ data, count ] = fread( fid, blocksize );
      if count == 0
         msg = 'File ended while scanning for magic number.';
         return
      end

      % Look for newline characters.
      nlchars = ( data == 10 ) | ( data == 13 );
      if any( nlchars )
         nlpos = find( nlchars );       % Position of newline chars.
         nlpos = nlpos(1);              % In case there are several.
         fseek( fid, nlpos - count, 0 );        % Put FPS at newline.
         break
      end

   end

end
