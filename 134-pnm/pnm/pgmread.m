function [X,map] = pgmread(filename)
%PGMREAD  Read a PGM (portable graymap) file from disk.
%
%   I = PGMREAD('FILENAME') reads the file 'FILENAME' and returns the
%   intensity image I.
%
%   [X,MAP] = PGMREAD('FILENAME') reads the file 'FILENAME' and returns
%   the indexed image X and associated color map MAP.
%
%   If file name has no suffix, '.pgm' is used.
%
%   PGMREAD can also read PBM images, but the output is always returned
%   as if the image read was a PGM image.
%
%   See also: PGMWRITE, PBMREAD, PBMWRITE, PPMREAD, PPMWRITE.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 21:26:38
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check number of input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error( nargchk( 1, 1, nargin ) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Identify output arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nargsout = nargout;
if ( nargsout == 1 )
   isindexed = 0;
elseif ( nargsout == 2 )
   isindexed = 1;
else
   error( 'Wrong number of output arguments.' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check filename.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( ~ischar( filename ) | isempty( filename ) )
   error( 'File name must be a non-empty string' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add suffix to file name if necessary.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k  = [ find( filename == filesep ) ];
if isempty(k)
   k = 0;
else
   k = max(k);
end
if all( filename(k+1:end) ~= '.' )
   filename = [ filename '.pgm' ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open input file for reading.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen( filename, 'r' );
if ( fid == -1 )
   error( [ 'Can''t open file ''' filename ''' for reading.' ] );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Identify file type.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Look for magic number.
[ magic, offset, msg ] = pnmmagic( fid );
if ~isempty( msg )
   fclose( fid );
   error( msg );
end

if ( magic == 'P1' ) | ( magic == 'P4' )        % Bitmap.

   fclose( fid );
   if isindexed
      [ X, map ] = pbmread( filename );         % Indexed bitmap.
   else
      X = pbmread( filename );                  % Intensity bitmap.
   end
   return;

elseif ( magic == 'P2' )                % Ascii encoded graymap.
   isascii = 1;

elseif ( magic == 'P5' )                % Binary encoded graymap.
   isascii = 0;

elseif ( magic == 'P3' ) | ( magic == 'P6' )    % Pixelmap.
   fclose( fid );
   error( 'File is a portable pixelmap, use PPMREAD instead.' );

else
   fclose( fid );
   error( 'File is neither a portable bitmap, graymap nor pixelmap.' );

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read image size and maximum pixel value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ header_data, count ] = pnmgeti( fid, 3 );
if count < 3
   fclose( fid );
   error( 'File ended while reading image header.' );
end

cols   = header_data(1);                % Number of columns in image.
rows   = header_data(2);                % Number of rows in image.
maxval = header_data(3);                % Maximum pixel value.
pixels = rows*cols;                     % Number of pixels in image.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read image data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isascii                              % Ascii encoded image.

   [ data, count, msg ] = pnmgeti( fid, pixels );
   if ~isempty( msg )
      fprintf( 2, 'Warning: %s\n', msg );
   end

else                                    % Binary encoded image.

   %
   % There should be a single byte of whitespace between the image
   % header data and the pixel area. Skip it.
   %
   fseek( fid, 1, 0 );

   [ data, count ] = fread( fid, pixels, 'uint8' );

   if ( count < pixels )
      disp( 'Warning: End of file reached too early.' );
   end

end

fclose( fid );                  % Close file.

if isindexed                    % Indexed graymap.

   X = zeros( cols, rows );     % Initialize index matrix.
   X(1:count) = data;           % Fill data into matrix.
   X = X' + 1;                  % Map [0,maxval] to [1,maxval+1].

   map = [0:maxval]'/maxval;    % Create grayscale vector.
   map = map(:,ones(1,3));      % Convert to RGB color map.

else                            % Intensity graymap.

   X = zeros( cols, rows );     % Initialize intensity matrix.
   X(1:count) = data;           % Fill read data into matrix.
   X = X'/maxval;               % Map values to [0,1] interval.

end
