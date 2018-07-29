function ppmwrite(arg1,arg2,arg3,arg4,arg5,arg6)
%PPMWRITE Write a PPM (portable pixmap) file to disk.
%
%   PPMWRITE(X,MAP,'FILENAME') writes a PPM file containing the indexed
%   image X and color map MAP to the file 'FILENAME'.
%
%   PPMWRITE(X,MAP,'FILENAME','ENCODING') where 'ENCODING' is either
%   'ascii' (or 'plain') or 'binary' (or 'raw') lets the user specify
%   whether the PPM file should be ascii or binary encoded. Default is
%   'ascii'.
%
%   PPMWRITE(R,G,B,'FILENAME') writes a PPM file containing the RGB
%   image in the matrices R,G,B to the file 'FILENAME'.
%
%   PPMWRITE(R,G,B,'FILENAME','ENCODING') allows the user to specify the
%   encoding as described above.
%
%   PPMWRITE(X,MAP,'FILENAME',MAXVALUE) uses MAXVALUE as the maximum
%   pixel value. This ables pixmaps with more than 256 values per color,
%   since the number of possible values is MAXVALUE+1.
%
%   PPMWRITE(X,MAP,'FILENAME',MAXVALUE,'ENCODING') lets the user specify
%   the output encoding as described above. Binary encoded pixmaps can
%   not have MAXVALUE larger than 255, so a MAXVALUE larger than 255
%   will always give an ascii encoded file regardless of the specified
%   output encoding.
%
%   PPMWRITE(R,G,B,'FILENAME',MAXVALUE) and
%   PPMWRITE(R,G,B,'FILENAME',MAXVALUE,'ENCODING') works as described
%   above, but on an RGB image.
%
%   The 'ascii' format is the most portable and is the only that allows
%   a MAXVALUE larger than 255, so it is also the most general. The
%   'binary' format files are, however, much smaller and many times
%   faster to read and write than the 'ascii' format.
%
%   If file name has no suffix, '.ppm' is used.
%
%   See also: PPMREAD, PBMREAD, PBMWRITE, PGMREAD, PGMWRITE.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 21:26:33
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

nargs = nargin;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check number of input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error( nargchk( 3, 6, nargs ) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Identify input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( nargs == 3 )               % 3 input arguments

   %
   % PPMWRITE(X,MAP,'FILENAME')
   %
   X = arg1;
   map = arg2;
   filename = arg3;
   maxval = 255;
   encoding = 'ascii';
   isindexed = 1;

elseif ( nargs == 6 )           % 6 input arguments

   %
   % PPMWRITE(R,G,B,'FILENAME',MAXVALUE,'ENCODING')
   %
   r = arg1;
   g = arg2;
   b = arg3;
   filename = arg4;
   maxval = arg5;
   encoding = arg6;
   isindexed = 0;

elseif ( nargs == 4 )           % 4 input arguments

   if ( ~ischar(arg3) & ischar(arg4) )

      %
      % PPMWRITE(R,G,B,'FILENAME')
      %
      r = arg1;
      g = arg2;
      b = arg3;
      filename = arg4;
      maxval = 255;
      encoding = 'ascii';
      isindexed = 0;

   elseif ( ischar(arg3) & ischar(arg4) )

      %
      % PPMWRITE(X,MAP,'FILENAME','ENCODING')
      %
      X = arg1;
      map = arg2;
      filename = arg3;
      encoding = arg4;
      maxval = 255;
      isindexed = 1;

   else

      %
      % PPMWRITE(X,MAP,'FILENAME',MAXVALUE)
      %
      X = arg1;
      map = arg2;
      filename = arg3;
      maxval = arg4;
      encoding = 'ascii';
      isindexed = 1;

   end

else                            % 5 input arguments

   if ( ischar(arg4) & ischar(arg5) )

      %
      % PPMWRITE(R,G,B,'FILENAME','ENCODING')
      %
      r = arg1;
      g = arg2;
      b = arg3;
      filename = arg4;
      encoding = arg5;
      maxval = 255;
      isindexed = 0;

   elseif ( ischar(arg4) & ~ischar(arg5) )

      %
      % PPMWRITE(R,G,B,'FILENAME',MAXVALUE)
      %
      r = arg1;
      g = arg2;
      b = arg3;
      filename = arg4;
      maxval = arg5;
      encoding = 'ascii';
      isindexed = 0;

   else

      %
      % PPMWRITE(X,MAP,'FILENAME',MAXVALUE,'ENCODING')
      %
      X = arg1;
      map = arg2;
      filename = arg3;
      maxval = arg4;
      encoding = arg5;
      isindexed = 1;

   end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These are no longer needed, so delete them to save memory.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear arg1 arg2 arg3 arg4 arg5 arg6

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The blocksize is the number of pixels written simultaneously.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

blocksize = 8192;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check the size of the R,G,B matrices.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isindexed
   if any( size(r) ~= size(g) ) | any( size(r) ~= size(b) )
      error( 'The R, G and B matrices must have the same size.' );
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check filename.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( ~ischar(filename) | isempty(filename) )
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
% Check and simplify the encoding specification.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~ischar(encoding)
   error( 'Encoding specification must be a string.' );
end

if any( encoding(1) == 'aApP' )         % 'ascii' (or 'plain') format.
   isascii = 1;
elseif any( encoding(1) == 'bBrR' )     % 'binary' (or 'raw') format.
   isascii = 0;
else
   error( 'Illegal encoding specification.' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximum pixel value can not be larger than 255 with binary encoding.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( ~isascii & ( maxval > 255 ) )
   disp( 'Warning:' );
   disp( 'Maximum pixel value must be <= 255 with binary encoding.' );
   disp( 'Using ascii encoding instead.' );
   encoding = 'ascii';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximum gray value smaller than 255 with binary encoding is not yet
% supported. :-(
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( ~isascii & ( maxval < 255 ) )
  error( 'MAXVAL less than 255 with binary encoding not supported.' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open output file for writing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen( filename, 'w' );
if ( fid == -1 )
   error( [ 'Can''t open file ''' filename ''' for writing.' ] );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get dimension of image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isindexed
   [ rows, cols ] = size( X );
else
   [ rows, cols ] = size( r );
end
pixels = rows*cols;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write file header.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Magic number.
if isascii
   magic = 'P3';
else
   magic = 'P6';
end

% Write header. Use FLOOR( CLOCK ) to avoid a second value of 60.
fprintf( fid, [ ...
   '%s\n', ...
   '# Created by Matlab (%s) %04d-%02d-%02d %02d:%02d:%02d\n', ...
   '%d %d\n', ...
   '%d\n' , ...
   ], magic, mfilename, floor( clock ), cols, rows, maxval );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pixels_written = 0;
char_count = 0;

while ( pixels_written < pixels )

   first_pixel = pixels_written + 1;
   last_pixel = min( pixels_written+blocksize, pixels );
   pixel = (first_pixel:last_pixel)';   % Pixels counted row-wise.
   row = ceil( pixel/cols );            % Row numbers.
   col = pixel - cols*(row-1);          % Column numbers.
   pixel = row + rows*(col-1);          % Pixels counted column-wise.

   pixels_to_write_now = last_pixel - first_pixel + 1;

   if isindexed
      int = round( maxval*map(X(pixel),:) );
   else
      int = round( maxval*[ r(pixel) g(pixel) b(pixel) ] );
   end

   int = int';
   int = int(:);

   if isascii                           % Write ascii format.
      for i = 1:3*pixels_to_write_now
         str = sprintf( '%d', int(i) ); % Integer as string.
         nstr = length( str );          % Length of string.
         if ( char_count+nstr >= 70 )   % If it does not fit on line...
            fprintf( fid, '\n' );       % ...add newline...
            char_count = 0;             % ...and reset counter...
         elseif ( char_count > 0 )      % If not beginning of line...
            fprintf( fid, ' ' );        % ...add blank...
            char_count = char_count+1;  % ...and increment counter.
         end
         fprintf( fid, str );           % Write string to file.
         char_count = char_count+nstr;  % Increment counter.
      end
   else                                 % Write binary format.
      fwrite( fid, int, 'uint8' );      % Write as unsigned 8 bit ints.
   end

   pixels_written = pixels_written + pixels_to_write_now;

end

fclose( fid );  % Close file.
