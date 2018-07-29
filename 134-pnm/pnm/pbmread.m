function [X,map] = pbmread(filename)
%PBMREAD  Read a PBM (portable bitmap) file from disk.
%
%   I = PBMREAD('FILENAME') reads the file 'FILENAME' and returns the
%   intensity image I.
%
%   [X,MAP] = PBMREAD('FILENAME') reads the file 'FILENAME' and returns
%   the indexed image X and associated color map MAP.
%
%   If file name has no suffix, '.pbm' is used.
%
%   See also: PBMWRITE, PGMREAD, PGMWRITE, PPMREAD, PPMWRITE.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 21:26:40
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
   filename = [ filename '.pbm' ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open input file for reading.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen( filename, 'r', 'ieee-be' );    % Big-endian byte ordering.
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

if ( magic == 'P1' )                            % Ascii encoded bitmap.
   isascii = 1;

elseif ( magic == 'P4' )                        % Binary encoded bitmap.
   isascii = 0;

elseif ( magic == 'P2' ) | ( magic == 'P5' )    % Graymap.
   fclose( fid );
   error( 'File is a portable graymap, use PGMREAD instead.' );

elseif ( magic == 'P3' ) | ( magic == 'P6' )    % Pixelmap.
   fclose( fid );
   error( 'File is a portable pixelmap, use PPMREAD instead.' );

else
   fclose( fid );
   error( 'File is neither a portable bitmap, graymap nor pixelmap.' );

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read image size.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ header_data, count ] = pnmgeti( fid, 2 );
if count < 2
   fclose( fid );                       % Close file.
   error( 'File ended while reading image header.' );
end

cols   = header_data(1);                % Number of columns.
rows   = header_data(2);                % Number of rows.
pixels = rows*cols;                     % Number of pixels.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read image data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isascii                              % Ascii encoded image.

   [ data, count, msg ] = pnmgeti( fid, pixels );
   fclose( fid );                       % Close file.

   if ~isempty( msg )
      fprintf( 2, 'Warning: %s\n', msg );
   end

   X = zeros( cols, rows );             % Initialize output matrix.
   X(1:count) = data;                   % Fill read data into matrix.
   X = X';

else                                    % Binary encoded image.

   %
   % There should be a single byte of whitespace between the image
   % header data and the pixel area. Skip it.
   %
   fseek( fid, 1, 0 );

   cols8   = 8*ceil( cols/8 );
   pixels8 = rows*cols8;

   % Read single bit integers.
   [ data, count ] = fread( fid, pixels8, 'ubit1' );
   fclose( fid );                       % Close file.

   if ( count < pixels8 )
      disp( 'Warning: End of file reached too early.' );
   end

   X = zeros( cols8, rows );            % Initialize output matrix.
   X(1:count) = data;                   % Fill data into matrix.
   X = X(1:cols,:)';

end

if isindexed                    % Indexed graymap.
   map = [ 0 0 0 ; 1 1 1 ];     % Create two-color color map.
   X = 2 - X;
else
   X = 1 - X;
end
