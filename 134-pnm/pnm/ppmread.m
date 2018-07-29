function [R,G,B] = ppmread(filename)
%PPMREAD  Read a PPM (portable pixmap) file from disk.
%
%   [R,G,B] = PPMREAD('FILENAME') reads the file 'FILENAME' and returns
%   the RGB image in the matrices R, G, and B.
%
%   [X,MAP] = PPMREAD('FILENAME') reads the file 'FILENAME' and returns
%   the indexed image X and associated color map MAP.
%
%   If file name has no suffix, '.ppm' is used.
%
%   PPMREAD can also read PGM and PBM images, but the output is always
%   returned as if the image read was a PPM image.
%
%   See also: PPMWRITE, PBMREAD, PBMWRITE, PGMREAD, PGMWRITE.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 21:26:37
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
if ( nargsout == 3 )
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
   filename = [ filename '.ppm' ];
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
      [ R, G ] = pbmread( filename );           % Indexed bitmap.
   else
      R = pbmread( filename );                  % Intensity bitmap.
      G = R;
      B = R;
   end
   return

elseif ( magic == 'P2' ) | ( magic == 'P5' )    % Graymap.

   fclose( fid );
   if isindexed
      [ R , G ] = pgmread( filename );          % Indexed graymap.
   else
      R = pgmread( filename );                  % Intensity graymap.
      G = R;
      B = R;
   end
   return

elseif ( magic == 'P3' )                % Ascii encoded pixelmap.
   isascii = 1;

elseif ( magic == 'P6' )                % Binary encoded pixelmap.
   isascii = 0;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read image size and maximum pixel value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ header_data, count ] = pnmgeti( fid, 3 );
if count < 3
   fclose( fid );                       % Close file.
   error( 'File ended while reading image header.' );
end

cols   = header_data(1);                % Number of columns in image.
rows   = header_data(2);                % Number of rows in image.
maxval = header_data(3);                % Maximum pixel value.

pixels = rows*cols;                     % Number of pixels in image.
values = 3*pixels;                      % Number of color values.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read image data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isascii                              % Ascii encoded image.

   [ data, count, msg ] = pnmgeti( fid, values );
   if ~isempty( msg )
      fprintf( 2, 'Warning: %s\n', msg );
   end

else                                    % Binary encoded image.

   %
   % There should be a single byte of whitespace between the image
   % header data and the pixel area. Skip it.
   %
   fseek( fid, 1, 0 );

   [ data, count ] = fread( fid, values, 'uint8' );
   if ( count < values )
      disp( 'Warning: End of file reached too early.' );
   end

end

fclose( fid );                          % Close file.

rvals = floor( (count+2)/3 );           % Number of red values.
gvals = floor( (count+1)/3 );           % Number of green values.
bvals = floor(  count   /3 );           % Number of blue values.

if isindexed                            % Indexed pixelmap.

   R = zeros( cols, rows );             % Initialize index matrix.
   R(1:pixels) = 1:pixels;              % Fill data into matrix.
   R = R';

   G = zeros( pixels, 3 );              % Initialize color map.
   G(1:rvals,1) = data(1:3:3*rvals);    % Insert red component.
   G(1:gvals,2) = data(2:3:3*gvals);    % Insert green component.
   G(1:bvals,3) = data(3:3:3*bvals);    % Insert blue component.
   G = G/maxval;                        % Map values to [0,1] interval.

else                                    % Intensity pixelmap.

   R = zeros(cols,rows);                % Initialize red component.
   G = zeros(cols,rows);                % Initialize green component.
   B = zeros(cols,rows);                % Initialize blue component.

   R(1:rvals) = data(1:3:3*rvals);      % Insert red component.
   G(1:gvals) = data(2:3:3*gvals);      % Insert green component.
   B(1:bvals) = data(3:3:3*bvals);      % Insert blue component.

   R = R'/maxval;                       % Map values to [0,1] interval.
   G = G'/maxval;                       % Map values to [0,1] interval.
   B = B'/maxval;                       % Map values to [0,1] interval.

end
